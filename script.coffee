#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'
{ spawnSync } = require 'child_process'

cmm1 = require './cmm1'
#cmm11 = require './cmm11'
cmm2 = require './cmm2'
memory = new cmm2.Memory

OUTPUT_DIR = './out'
MS_PER_SEC = 1e3
NANOSECONDS_PER_MS = 1e6
REPETITIONS = 3

fs.mkdirSync(OUTPUT_DIR) unless fs.existsSync(OUTPUT_DIR)

range = (b, e, i) -> (x for x in [b..e] by i)

TESTS =
    primality: range(1, 10, 1)
    fibonacci: range(25, 50, 5)
    collatz: range(10000, 50000, 5000)
    matrixmul: range(50, 350, 50)

useTimer = (file, value) ->
    { stderr: output } = spawnSync "timer", ['-ni', file, value], encoding: 'utf-8'

    { elapsed } = JSON.parse output

    elapsed/1000 # Elapsed is in microseconds, result in milliseconds

cmmMeasure = (file, value, compileFn, compileTransform, runFn) ->
    compilation = compileTransform compileFn(fs.readFileSync(file, 'utf-8'))

    start = process.hrtime()
    runFn(compilation, value.toString())
    diff = process.hrtime(start)

    [ seconds, nanoseconds ] = diff

    seconds*MS_PER_SEC + nanoseconds/NANOSECONDS_PER_MS

###
runcmm11 = (ast, input) ->
    iterator = cmm11.execute(ast, input)
    done = false
    until done
        { done } = iterator.next()
###

measureTime =
    cmm2: (file, value) -> cmmMeasure(file, value, cmm2.compile, ((x)-> x.program.attachMemory(memory); x.program), cmm2.runSync)
    cmm1: (file, value) -> cmmMeasure(file, value, cmm1.compile, ((x)->x), cmm1.execute)
    #cmm11: (file, value) -> cmmMeasure(file, value, cmm11.compile, ((x)->x), runcmm11)
    cc: (file, value) -> useTimer file[...-3], value # Remove .cc extension(executable has no extension)
    js: useTimer
    py: useTimer

extNames = Object.keys(measureTime)

results = {}

shouldPerformTest = (language, test, value) ->
    if test is 'fibonacci'
        if ((language.indexOf('cmm') >= 0 and value > 35) or (language is 'py' and value > 40))
            return no

    if test is 'matrixmul'
        if language in ['cmm1', 'cmm11']
            return no

    return yes

for test, values of TESTS
    languages = {}

    for file in fs.readdirSync("./#{test}") when (extension = path.extname(file)[1..]).length > 0
        languages[extension] = path.join "./#{test}", file

    languages.cmm1 = languages.cmm11 = languages.cmm2 = languages.cmm
    delete languages.cmm

    results[test] = {}

    for language in extNames
        file = languages[language]
        results[test][language] = []
        for value in values
            if shouldPerformTest(language, test, value)
                timeAvg = 0
                for times in [0...REPETITIONS]
                    time = measureTime[language](file, value)
                    timeAvg += time
                timeAvg /= REPETITIONS
                console.log { language, file, value, time: timeAvg/1000 }
                results[test][language].push timeAvg

for test, resultTest of results
    file = path.join(OUTPUT_DIR, "#{test}.csv")
    content = "N,#{extNames.join(',')}"

    for N, i in TESTS[test]
        content += "\n#{N}"
        for ext in extNames
            content += ",#{if resultTest[ext][i]? then Math.round resultTest[ext][i] else ""}"

    fs.writeFileSync file, content
