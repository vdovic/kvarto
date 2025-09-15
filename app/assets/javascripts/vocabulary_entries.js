(function() {
  function handleFlashcard() {
    var $container = $('.vocabulary-study');
    if (!$container.length) { return; }

    var $translation = $container.find('[data-role="translation"]');
    var $contextSections = $container.find('[data-role="example"], [data-role="notes"]');
    var $toggleTranslation = $container.find('[data-action="toggle-translation"]');
    var $toggleContext = $container.find('[data-action="toggle-context"]');

    $toggleTranslation.off('click.lexicon').on('click.lexicon', function(event) {
      event.preventDefault();
      toggleSection($translation, $(this), 'Reveal translation', 'Hide translation');
    });

    $toggleContext.off('click.lexicon').on('click.lexicon', function(event) {
      event.preventDefault();
      if (!$contextSections.length) { return; }

      var anyVisible = false;
      $contextSections.each(function() {
        if (!$(this).hasClass('is-hidden')) { anyVisible = true; }
      });

      if (anyVisible) {
        $contextSections.addClass('is-hidden');
        $(this).text('Show context');
      } else {
        $contextSections.removeClass('is-hidden');
        $(this).text('Hide context');
      }
    });
  }

  function toggleSection($section, $button, showText, hideText) {
    if (!$section.length) { return; }

    if ($section.hasClass('is-hidden')) {
      $section.removeClass('is-hidden');
      if ($button && showText && hideText) { $button.text(hideText); }
    } else {
      $section.addClass('is-hidden');
      if ($button && showText && hideText) { $button.text(showText); }
    }
  }

  var events = ['ready', 'turbolinks:load', 'page:load'];
  $.each(events, function(_, eventName) {
    $(document).on(eventName, handleFlashcard);
  });
})();
