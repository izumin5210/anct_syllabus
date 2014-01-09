exports.index = (req, res) ->
  cheerio = require 'cheerio'
  _ = require 'underscore'
  Course = require './../models/course'
  fs = require 'fs'
  fs.readFile 'public/xml/syllabus2013.xml', 'utf8', (err, xml) ->
    if err?
      res.writeHead 404, 'Content-Type: text/plain'
      res.write 'not found'
    else
      if _.keys(req.query).length > 0
        $ = cheerio.load xml, { ignoreWhitespave: true, xmlMode: true }
        courses = _.map $(xml).find('Course'), (course) -> new Course($(course))
        courses = _.select courses, (course) -> course.is(req.query)
        res.render 'list', courses: courses
      else
        res.render 'index'

