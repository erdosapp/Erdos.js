module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    meta:
      file: 'erdos'
      endpoint: 'package',
      banner: '/* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("yyyy/m/d") %>\n' +
              '   <%= pkg.homepage %>\n' +
              '   Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>' +
              ' - Licensed under <%= pkg.license %> */\n'

    resources:
      src: [
        'src/**/*.coffee'

      ]
      spec: [
        'spec/*_spec.coffee'
      ]

    browserify: 
      debug: 
        files: 
          'dist/<%= meta.file %>-debug.js': ['index.js']
        options: 
          standalone: 'erdosjs'
          debug: true
          # transform: ['coffeeify']
      dist: 
        files: 
          'dist/<%= meta.file %>.js': ['index.js']
        options:
          standalone: 'erdosjs'

    uglify:
      options:
        compress: true
        banner: '<%= meta.banner %>'
      endpoint:
        files: 'dist/<%=meta.file%>.js':  'dist/<%= meta.file %>.js'

    coffee:
      node: 
        src: ['**/*.coffee']
        cwd: 'src'
        dest: 'lib/'
        expand: true
        ext: '.js'
        options:
          bare: true

    mochaTest:
      spec: 
        options: 
          reporter: 'spec',
          require: ['coffee-script']

        src: ['spec/**/*_specc.coffee']

    watch:
      src:
        files: '<%= resources.src %>'
        tasks: ['spec']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-coffeeify'

  grunt.registerTask 'spec', ['coffee:node', 'mochaTest:spec']
  grunt.registerTask 'browser', ['coffee:node', 'browserify:debug', 'browserify:dist']
  grunt.registerTask 'default', ['spec']
