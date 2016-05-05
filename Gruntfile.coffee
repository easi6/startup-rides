'use strict'
mountFolder = (connect, dir) ->
  connect.static require('path').resolve dir

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)
  grunt.initConfig
    app:
      paths:
        dist: 'dist'
        tmp: '.tmp'
    env:
      dev:
        BASE: ".tmp"
      dist:
        BASE: "dist"
    pkg: grunt.file.readJSON 'package.json'
    connect:
      options:
        port: 8080
        livereload: 35729
        hostname: '0.0.0.0'
      livereload:
        options:
          open: true
          base: '<%= process.env.BASE%>'

    watch:
      options:
        livereload: true
        event: ['changed', 'added', 'deleted']
      less:
        files: ['assets/styles/**/*.less']
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
      reload:
        files: ['<%= process.env.BASE %>/**/*']
        options:
          livereload: true
    less:
      options:
        paths: ["assets/styles"]
      compile:
        files: [
          expand: true
          cwd: "assets/styles"
          src: ['**/*.less']
          dest: '<%= process.env.BASE %>/css'
          ext: ".css"
        ]
    cssmin:
      dist:
        files: {
          "dist/css/main.css": ["<%= app.paths.tmp%>/css/*.css"]
        }

    uglify:
      dist:
        files:
          'dist/js/main.min.js': ['dist/js/main.js']
    open:
      # change to the port you're using
      server:
        path: "http://localhost:<%= connect.options.port %>?LR-verbose=true"
    pug:
      compile:
        files: [
          expand: true
          cwd: "views"
          src: ["*.pug"]
          ext: ".html"
          dest: "<%= process.env.BASE %>"
        ]
    copy:
      img:
        files: [
            expand: true
            src: ['**/*']
            cwd: 'assets/images'
            dest: '<%= process.env.BASE %>/img/'
        ]
      styles:
        files: [
            expand: true
            src: ['**.css']
            cwd: 'assets/styles'
            dest: '<%= process.env.BASE %>/css/'
        ]
      scripts:
        files: [
            expand: true
            src: ['**.{js,json}']
            cwd: 'assets/scripts'
            dest: '<%= process.env.BASE %>/js/'
        ]
      bower:
        files: [
          expand: true
          src: ['**']
          cwd: 'assets/bower_components'
          dest: '<%= process.env.BASE %>/bower/'
        ]
    clean: ['dist', '.tmp']

  grunt.registerTask 'server', [ 'clean', 'env:dev', 'copy', 'pug', 'less', 'connect:livereload', 'open', 'watch' ]
  grunt.registerTask 'build', [ 'clean', 'copy', 'pug', 'less', 'cssmin:dist', 'uglify']
