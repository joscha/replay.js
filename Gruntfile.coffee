module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    meta:
      banner: """/*!
                  * <%= pkg.title || pkg.name %> - <%= pkg.description %>
                  * v<%= pkg.version %> - <%= grunt.template.today("UTC:yyyy-mm-dd h:MM:ss TT Z") %>
                  * <%= pkg.homepage %>
                  * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>; License: <%= pkg.license %>
                  */

              """

    mochaTest:
      test:
        options:
          reporter: 'dot'
        src: [
          'test/**/*.coffee'
        ]
      watch:
        options:
          reporter: 'min'
        src: [
          'test/**/*.coffee'
        ]        

    coffee:
      glob:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: 'src/',
        src: [
          '*.coffee'
        ],
        dest: 'lib/',
        ext: '.js'

    uglify:
      options:
        banner: "<%= meta.banner %>"
      coffee:
        options:
          sourceMap: 'lib/replay.min.js.map'
        files:
          'lib/replay.min.js': ['lib/replay.js']

    watch:
      src:
        files: ['src/**/*.coffee', 'package.json']
        tasks: ['coffee']
      test:
        files: ['src/**/*.coffee', 'test/**/*.coffee']
        tasks: ['mochaTest:watch']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'dist', ['coffee', 'uglify']

  grunt.registerTask "test", ['mochaTest:test']
  grunt.registerTask "default", ['test', 'dist']