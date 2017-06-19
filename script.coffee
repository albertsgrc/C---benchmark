#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'
{ spawnSync } = require 'child_process'

cmm1 = require './cmm1'
#cmm11 = require './cmm11'
cmm2 = require './cmm2'
memory = new cmm2.Memory

OUTPUT_DIR = './out'
NS_PER_SEC = 1e9
REPETITIONS = 3

fs.mkdirSync(OUTPUT_DIR) unless fs.existsSync(OUTPUT_DIR)

range = (b, e, i) -> (x for x in [b..e] by i)

TESTS =
    is_prime: range(1, 10, 1)
    fibonacci: range(25, 50, 5)
    collatz: range(10000, 50000, 5000)

useTimer = (file, value) ->
    command = "timer"

    { stderr: output } = spawnSync command, ['-ni', file, value], encoding: 'utf-8'

    { elapsed } = JSON.parse output

    elapsed/1000

cmmMeasure = (file, value, compileFn, compileTransform, runFn) ->
    compilation = compileTransform compileFn(fs.readFileSync(file, 'utf-8'))

    start = process.hrtime()
    runFn(compilation, value.toString())
    diff = process.hrtime(start)

    (diff[0]*NS_PER_SEC + diff[1])/1000000

runcmm1 = (ast, input) ->
    iterator = cmm11.execute(ast, input)
    done = false
    until done
        { done } = iterator.next()

measureTime =
    cmm2: (file, value) -> cmmMeasure(file, value, cmm2.compile, ((x)-> x.program.attachMemory(memory); x.program), cmm2.runSync)
    cmm1: (file, value) -> cmmMeasure(file, value, cmm1.compile, ((x)->x), cmm1.execute)
#    cmm11: (file, value) -> cmmMeasure(file, value, cmm11.compile, ((x)->x), runcmm1)
    cc: (file, value) -> useTimer file[...-3], value
    js: useTimer
    py: useTimer

extNames = Object.keys(measureTime)

results = {}

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
            if test is 'fibonacci' and ((language.indexOf('cmm') >= 0 and value > 35) or (language is 'py' and value > 40))
                continue
            else
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
