# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(->
  show_screen_image = (e)->
    document.location = e.target.src.replace('screen_','');

  $(".imageviewer .thumbs a").each((thumbi, thumb) ->
    $(thumb).click((e)->
      image_url = $(e.currentTarget).attr("href")
      show_area = $(e.target).closest(".imageviewer").find("img.show")
      show_area.attr("src",image_url)
      show_area.click(show_screen_image)
      return false;
    )
  )
  $("img.show").click(show_screen_image)

  $("form#new_work").on("submit", ->
    d = new Date()
    d.setHours(24)
    docCookies.setItem("lastLocation", $("form#new_work input#work_location").val(), d);
  );

  $("form#new_work input#work_location").val(docCookies.getItem("lastLocation"));

  show_or_hide_selected_works = ->
    selected_works_count = $(".work.panel input[type=checkbox]:checked").length
    if selected_works_count > 0
      $("#selected-works-count").html(selected_works_count)
      $("#selected-works").show()
      cluster_existing = $("#cluster_existing").val()
      if cluster_existing
        $("#new-cluster-name").hide()
      else
        $("#new-cluster-name").show()
    else
      $("#selected-works").hide()

  show_or_hide_selected_works()

  $("body").on("change",".work.panel input[type=checkbox], #cluster_existing", ->
    show_or_hide_selected_works()
  )

)