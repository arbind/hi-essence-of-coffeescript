$ = $ || jQuery

class EssenceOfCoffeeScript.Exercise extends Backbone.View
  initialize: (attributes)=>
    super attributes
    _.extend @options, EssenceOfCoffeeScript.options

    { @$elExerciseModel, @course, @lessonPlan, @idx } = attributes
    @materializeModel @$elExerciseModel
    @$title = @$('.title')
    @$headline = @$('.headline')
    @$realization = @course.$('.realization')
    @$description = @$('.description')
    @$instructions= @$('.instructions')
    @$instructionList= @$('.instructions ol')

    @quote = @$('quote').text().trim()

    @$navbarButton = $("<input class='show-exercise' type='submit' value='#{@idx + 1}' data-idx='#{@idx}'/>")
    @lessonPlan.$navbar.append $("<li></li>").append(@$navbarButton)

    @$navbarButton = @lessonPlan.$navbar.find("li input[data-idx=#{@idx}]")

    @deactivate()

  materializeModel: (@$elExerciseModel)=>
    atts = @$elExerciseModel.pickHTMLValues 'title',
      'headline',
      'description',
      'realization',
      'instruction',
      'user-console',
      'factoid'
    codeAtts = @$elExerciseModel.pickTextValues 'js-syntax',
      'coffee-syntax',
      'example-code',
      'given-code',
      'user-code',
      'user-console',
    atts = _.extend atts, codeAtts
    atts.instruction = [atts.instruction] if 'string' is typeof atts.instruction
    @model = new Backbone.Model atts

  activate: ()=>
    $html = $('html, body')

    @$headline.html @model.get 'headline'
    @$realization.html @model.get 'realization'
    @$description.html @model.get 'description'
    @$instructionList.html ''
    if @model.get('instruction')?.length > 0
      for instruction in @model.get 'instruction' 
        @$instructionList.append "<li class='instruction'>#{instruction}</li>"
      @$instructions.fadeIn()

    if @model.get('realization')? then @$realization.fadeIn() else @$realization.fadeOut()
    if @model.get('description')? then @$description.fadeIn() else @$description.fadeOut()
    if @model.get('instruction')?.length > 0 then @$instructions.fadeIn() else @$instructions.fadeOut()

    @course.javaScriptSyntaxEditor.hide()
    @course.coffeeScriptSyntaxEditor.hide()
    @course.exampleCodeEditor.hide()
    @course.givenCodeEditor.hide()
    @course.userCodeEditor.hide()

    @course.javaScriptSyntaxEditor.show @model.get 'js-syntax' if @model.get('js-syntax')?
    @course.coffeeScriptSyntaxEditor.show @model.get 'coffee-syntax' if @model.get('coffee-syntax')?
    @course.exampleCodeEditor.show @model.get 'example-code' if @model.get('example-code')?
    @course.givenCodeEditor.show @model.get 'given-code' if @model.get('given-code')?.length > 0
    @course.userCodeEditor.show('') if @model.get('user-code')?
    
    @$el.delay(@options.fadeOutDuration + 10).fadeIn(@options.fadeInDuration)
    @$navbarButton.addClass('active')
    @

  deactivate: ()=> @$navbarButton.removeClass('active')
