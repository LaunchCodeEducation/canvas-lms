import I18n from 'i18n!catalog'
import $ from 'jquery'
import 'jqueryui/dialog'

function fetchCourses () {
  $('#catalog_content').load(window.location.href)
}

function handleNav (e) {
  let url
  if (!history.pushState) { return }
  if (this.href) {
    url = this.href
  } else {
    url = `${this.action}?${$(this).serialize()}`
  }
  history.pushState(null, '', url)
  fetchCourses()
  e.preventDefault()
}

function handleCourseClick (e) {
  const link = $(e.target).closest('.course_enrollment_link')[0]
  if (!link) {
    const $course = $(e.target).closest('.course_summary')
    if ($course.length && !$(e.target).is('a')) {
      $course.find('h3 a')[0].click()
    }
    return
  }
  const $dialog = $('<div>')
  const $iframe = $('<iframe>', {
    style: 'position:absolute;top:0;left:0;width:100%;height:100%;border:none',
    src: `${link.href}?embedded=1&no_headers=1`,
    title: I18n.t('Course Catalog')
  })
  $dialog.append($iframe)
  $dialog.dialog({
    width: 550,
    height: 500,
    resizable: false
  })
  e.preventDefault()
}

$('#course_filter').submit(handleNav)
$('#catalog_content').on('click', '#previous-link', handleNav)
$('#catalog_content').on('click', '#next-link', handleNav)
$('#catalog_content').on('click', '#course_summaries', handleCourseClick)
window.addEventListener('popstate', fetchCourses)
