$ = jQuery

$.fn.exists = ()-> this.length>0

$.fn.getAttributes = ()->
  atts = {}
  return atts unless @length
  $.each @[0].attributes, (index, att)-> atts[att.name] = att.value
  atts

$.fn.textValue = (attName)->
  return undefined unless @length
  $e = @find(".#{attName}")
  return undefined unless $e
  switch $e.length
    when 0 then null
    when 1 then $e.text().trim()
    else $(item).text().trim() for item in $e # return an array

$.fn.htmlValue = (attName)->
  return undefined unless @length
  $e = @find(".#{attName}")
  return undefined unless $e
  switch $e.length
    when 0 then null
    when 1 then $e.html().trim()
    else $(item).html().trim() for item in $e # return an array


$.fn.pickTextValues = (attNames...)->
  return undefined unless @length
  textValues = {}
  textValues[name] = @.textValue(name) for name in attNames
  textValues

$.fn.pickHTMLValues = (attNames...)->
  return undefined unless @length
  textValues = {}
  textValues[name] = @.htmlValue(name) for name in attNames
  textValues



$.fn.htmlElement= ()->
  return null unless @length
  stringHTML = @html()
  $(stringHTML)[0]

$.fn.autoAdjustAceEditorHeight = (aceEditor, options)->
  $editor = @
  $parent = @parent()
  options = {} unless options?
  options.minHeight = 24 unless options.minHeight?
  options.maxHeight = null unless options.maxHeight?
  options.adjustParent = true unless adjustParent?
  parentOverSize = $parent.height() - $editor.height()
  parentOverSize = 0 if parentOverSize < 0

  aceEditorHeight = ()=>
    screenLength = aceEditor.getSession().getScreenLength()
    lineHeight = aceEditor.renderer.lineHeight
    lineHeight = 12 if lineHeight < 8
    scrollBarWidth = aceEditor.renderer.scrollBar.getWidth()
    padding = parseInt(@find('.ace_scroller').css('padding'))
    h = screenLength * lineHeight + scrollBarWidth
    h = options.minHeight if h < options.minHeight
    h = maxHeight if options.maxHeight? and h > options.maxHeight
    h = h + (2 * padding)
    h

  autoAdjustHeightFunctor = (e)=>
    return if e? and e.data?.text isnt '\n' # auto adjust only on enter key or if there is no event
    window.clearTimeout(aceEditor.autoAdjustTimer) if aceEditor.autoAdjustTimer?

    trigger = ()=> # hack to keep resizing for 5 seconds after a change, allowing an editor to animate into view
      aceEditor.elapsedResizeTime += 100
      return if 5000 < aceEditor.elapsedResizeTime
      h = aceEditorHeight()

      if h is aceEditor.elapsedResizeHeight
        aceEditor.autoAdjustTimer = window.setTimeout trigger, 100
        return 
      aceEditor.elapsedResizeHeight = h
      @height(h)
      @parent().height(h + parentOverSize) if options.adjustParent
      aceEditor.resize(true)
      aceEditor.autoAdjustTimer = window.setTimeout trigger, 100

    aceEditor.elapsedResizeTime = 0
    aceEditor.elapsedResizeHeight = -1.1
    clearTimeout(aceEditor.autoAdjustTimer)
    aceEditor.autoAdjustTimer = window.setTimeout trigger, 100

  aceEditor.on 'change', autoAdjustHeightFunctor
  aceEditor.onChangeFold autoAdjustHeightFunctor

  aceEditor.autoAdjustHeight = -> autoAdjustHeightFunctor(null)
