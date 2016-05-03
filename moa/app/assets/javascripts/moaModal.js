$(document).ready( function () {
  $('#moaModal').on('show.bs.modal', function (event) {
    var link = $(event.relatedTarget)
    var image = link.data('image')
    var modal = $(this)
    modal.find('.modal-title').text(image.ghash)
    modal.find('.modal-body img').attr('src', image.url)
    modal.find('.modal-footer a').attr('href', 'https://img.berkeley-pbl.com/images/' + image.ghash)
  })
})

