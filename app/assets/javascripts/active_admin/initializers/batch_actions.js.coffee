$(document).on 'ready page:load', ->
  # In order for index scopes to overflow properly onto the next line, we have
  # to manually set its width based on the width of the batch action button.
  if (batch_actions_selector = $('.table_tools .batch_actions_selector')).length
    batch_actions_selector.next().css
      width: "calc(100% - 10px - #{batch_actions_selector.outerWidth()}px)"
      'float': 'right'
