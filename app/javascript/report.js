var reportInit;

reportInit = function() {
  $('#locaties tr').hide();
  return $('#locaties tr.location_raw, #locaties tr.span-6').show();
};
reportInit();

$(document).on('turbolinks:load', reportInit);

$(document).on('click', '#locaties tr.span-6 td[colspan], #locaties tr.span-4 td[colspan]', function(event_super_row_click) {
  var $super_row;
  // console.log(event_super_row_click)
  $super_row = $(event_super_row_click.target).parent();
  if ($super_row.hasClass('expanded')) {
    $super_row.removeClass('expanded');
    if ($super_row.hasClass('span-6')) {
      return $super_row.nextUntil('.span-6').hide().removeClass('expanded');
    } else if ($super_row.hasClass('span-4')) {
      return $super_row.nextUntil('.span-4').hide().removeClass('expanded');
    }
  } else {
    $super_row.addClass('expanded');
    if ($super_row.hasClass('span-6')) {
      return $super_row.nextUntil('.span-6', '.span-5, .span-4').show();
    } else if ($super_row.hasClass('span-4')) {
      return $super_row.nextUntil('.span-4, .span-6', '.span-3, .span-2').show();
    }
  }
});

$(document).on('change', '#report_filter input', function(event) {
  document.querySelectorAll("button[name=filter_on]").forEach(function(element) {
    element.innerText = element.innerText.replace(/\d/g, "")
  })
})


$(document).on('change', '#report_filter input', function(event) {
  const changeEvent = document.createEvent('HTMLEvents');
  changeEvent.initEvent('change', true, false);

  const target = event.target;
  const parentKeyValue = JSON.parse(target.dataset.parent);
  if (event.target.checked) {
    for (const key in parentKeyValue) {
      const value = parentKeyValue[key];
      const input = document.querySelector("#report_filter input[name='"+key+"'][value='"+value+"']");
      input.checked = true;
      input.dispatchEvent(changeEvent);
    }
  } else {
    const groupId = target.parentElement.parentElement.dataset.group
    if (document.querySelectorAll("tr[data-group='"+groupId+"'] input:checked").length == 0) {
      for (const key in parentKeyValue) {
        const value = parentKeyValue[key];
        const input = document.querySelector("#report_filter input[name='"+key+"'][value='"+value+"']");
        input.checked = false;
        input.dispatchEvent(changeEvent);
      }
    }
  }
})