# Gulpfile

## Imports

> General

    gulp      = require 'gulp'
    pump      = require 'pump'
    del       = require 'del'

> Gulp Plugins

    coffee    = require 'gulp-coffeescript'
    lint      = require 'gulp-coffeelint'
    rollup    = require 'rollup-stream'
    source    = require 'vinyl-source-stream'

    mocha     = require 'gulp-spawn-mocha'

> Rollup Plugins

    resolve   = require 'rollup-plugin-node-resolve'
    commonjs  = require 'rollup-plugin-commonjs'
    builtins  = require 'rollup-plugin-node-globals'
    cleanup   = require 'rollup-plugin-cleanup'

## Tasks

### Default

    gulp.task 'default', ['test', 'coffee', 'rollup'], ->

### Clean

    gulp.task 'clean', -> del 'build'

### Coffee

    gulp.task 'coffee', ['clean', 'lint'], -> pump [

      gulp.src './src/**/*.litcoffee'
      coffee { bare: true, literate: true }
      gulp.dest './build'

    ]

## Lint

    gulp.task 'lint', -> pump [

      gulp.src './src/**/*.litcoffee'
      lint true
      lint.reporter 'coffeelint-stylish'
      lint.reporter 'fail'

    ]

## Rollup

    gulp.task 'rollup', ['coffee'], -> pump [

      rollup {

        input: './build/index.js'
        format: 'cjs'

        external: [ 'events' ]

        plugins: [

          resolve { preferBuiltins: true }

          commonjs()

          cleanup()

        ]

      }

      source 'index.js'
      gulp.dest '.'

    ]

## Test

    gulp.task 'test', ['lint'], -> pump [

      gulp.src './test/**/*.litcoffee'

      mocha {
        require: './test/setup'

        istanbul: true
      }

    ]

### TDD

    gulp.task 'tdd', ['test'], ->
      gulp.watch ['src/**/*.litcoffee', 'test/**/*.litcoffee'], ['test']