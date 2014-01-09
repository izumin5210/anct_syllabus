class Course

  constructor: (course) ->
    cheerio = require 'cheerio'
    _ = require 'underscore'
    @title = course.find('Title').text()
    @etitle = course.find('ETitle')
    @department = course.find('Department').text()
    @year = course.find('Year').text()
    @required = course.find('RequiredSelective').text()
    @divide = course.find('Divide').text()
    @term = course.find('Term').text()
    @credit = course.find('Credit').text()
    @lectures = _.map course.find('Lecturer'), (l) ->
      $ = cheerio.load l, { ignoreWhitespace: true, xmlMode: true }
      $(l).text()
    @failureAbsence = course.find('FailureAbsence').text()
    @evaluation = course.find('Evaluation').text()

  isDept: (dept) -> @eDept() == dept

  eDept: ->
    switch @department
      when '機械工学科' then 'm'
      when '電気情報工学科' then 'e'
      when '電気情報工学科 電気電子工学コース' then 'e'
      when '電気情報工学科 情報工学コース' then 'e'
      when '都市システム工学科' then 'c'
      when '建築学科' then 'a'

  eCourse: ->
    if @eDept(@department) == 'e'
      switch @department
        when '電気情報工学科 電気電子工学コース' then return 'd'
        when '電気情報工学科 情報工学コース' then return 'j'
        else return null
    else
      return null

  is: (query) ->
    result = true
    if query.year? then result &= (query.year == @year)
    if query.department? then result &= @isDept(query.department)
    if query.course? && @year > 3 && @eDept() == 'e' then result &= (query.course == @eCourse())
    result

module.exports = Course
