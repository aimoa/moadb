$ ->
  $('#moaModal').on 'show.bs.modal', (event) ->
    link = $(event.relatedTarget)
    image = link.data('image')
    modal = $(this)
    modal.find('.modal-title').text(image.ghash)
    modal.find('.modal-body img').attr('src', image.url)
