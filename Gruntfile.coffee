'use strict'
mountFolder = (connect, dir) ->
  connect.static require('path').resolve dir

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    connect:
      server:
        options:
          port: 9999
          hostname: '*'
          base: 'dist'
          middleware: (connect) ->
            [ require('connect-livereload')(ignore:[]), mountFolder(connect, '.tmp'), mountFolder(connect, 'dist')]
    watch:
      options:
        livereload: true
        event: ['changed', 'added', 'deleted']
      less:
        files:
          ['assets/styles/**/*.less']
        tasks: 'less'
        options:
          livereload: false
      css:
        files:
          ['assets/styles/**/*.css']
        tasks: 'copy:styles'
        options:
          livereload: false
      js:
        files:
          ['assets/scripts/**/*.{js,json}']
        tasks: 'copy:scripts'
        options:
          livereload: false
      pug:
        files:
          ['views/**/*.pug']
        tasks: 'pug'
        options:
          livereload: false
      img:
        files:
          ['assets/images/**/*']
        tasks: 'copy:img'
        options:
          livereload: false
      bower:
        files:
          ['assets/bower_components/**/*']
        tasks: 'copy:bower'
        options:
          livereload: false
    less:
      development:
        options:
          paths: ["assets/styles"]
        files:
          'dist/css/main.css': 'assets/styles/main.less'
    cssmin:
      dist:
        files:
          'dist/css/ver2.min.css': 'dist/css/ver2.css'
    uglify:
      dist:
        files:
          'dist/js/main.min.js': ['dist/js/main.js']
    open:
      # change to the port you're using
      server:
        path: "http://localhost:<%= connect.server.options.port %>?LR-verbose=true"
    pug:
      compile:
        files:
          "dist/index.html": ["views/index.pug"],
          "dist/apply.html": ["views/apply.pug"]
    copy:
      img:
        files: [
            expand: true
            src: ['**']
            cwd: 'assets/images'
            dest: 'dist/img/'
        ]
      styles:
        files: [
            expand: true
            src: ['**.css']
            cwd: 'assets/styles'
            dest: 'dist/css/'
        ]
      scripts:
        files: [
            expand: true
            src: ['**.{js,json}']
            cwd: 'assets/scripts'
            dest: 'dist/js/'
        ]
      bower:
        files: [
          expand: true
          src: ['**']
          cwd: 'assets/bower_components'
          dest: 'dist/bower/'
        ]
    clean: ['dist']

  grunt.registerTask 'server', [ 'clean', 'copy', 'pug', 'less', 'cssmin', 'uglify', 'connect:server', 'open', 'watch' ]
  grunt.registerTask 'build', [ 'clean', 'copy', 'pug', 'less', 'cssmin', 'uglify']
