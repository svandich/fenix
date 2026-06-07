document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.quiz-option').forEach(function (label) {
    label.addEventListener('click', function () {
      var input = label.querySelector('input[type="radio"]');
      if (input.disabled) return;
      var name = input.name;
      document.querySelectorAll('input[name="' + name + '"]').forEach(function (r) {
        r.closest('.quiz-option').classList.remove('selected');
      });
      label.classList.add('selected');
    });
  });
});

function checkQuiz(id, correct) {
  var q = document.getElementById(id);
  var checked = q.querySelector('input:checked');
  if (!checked) return;
  var sel = parseInt(checked.value);

  q.querySelectorAll('.quiz-option').forEach(function (opt, i) {
    opt.style.pointerEvents = 'none';
    opt.querySelector('input').disabled = true;
    if (i === correct) opt.classList.add('correct');
    else if (i === sel) opt.classList.add('incorrect');
  });

  q.querySelector('.quiz-btn').disabled = true;

  var expEl = document.getElementById(id + '-exp');
  var explanation = expEl ? expEl.textContent : '';
  var prefix = sel === correct
    ? '<span class="fb-correct">✓ Correcto.</span> '
    : '<span class="fb-incorrect">✗ Incorrecto.</span> ';

  var fb = document.getElementById(id + '-fb');
  fb.innerHTML = prefix + explanation;
  fb.style.display = 'block';

  if (window.MathJax && MathJax.typesetPromise) MathJax.typesetPromise([fb]);
}
