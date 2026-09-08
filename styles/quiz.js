document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.quiz-options').forEach(function (group) {
    var quizQ = group.closest('.quiz-q');
    group.querySelectorAll('input[type="radio"]').forEach(function (radio) {
      radio.addEventListener('change', function () {
        if (radio.disabled) return;
        group.querySelectorAll('.quiz-option').forEach(function (opt) {
          opt.classList.remove('selected');
        });
        radio.closest('.quiz-option').classList.add('selected');
        if (quizQ && quizQ.dataset.correct !== undefined) {
          checkQuiz(quizQ.id, parseInt(quizQ.dataset.correct));
        }
      });
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

  var btn = q.querySelector('.quiz-btn');
  if (btn) btn.disabled = true;

  var expEl = document.getElementById(id + '-exp');
  // El texto de la explicacion ya trae su MathML horneado (ver
  // scripts/inline-mathml.py); innerHTML lo parsea y el navegador lo
  // renderiza sin ayuda de ningun script.
  var explanation = expEl ? expEl.textContent : '';
  var prefix = sel === correct
    ? '<span class="fb-correct">✓ Correcto.</span> '
    : '<span class="fb-incorrect">✗ Incorrecto.</span> ';

  var fb = document.getElementById(id + '-fb');
  fb.innerHTML = prefix + explanation;
  fb.style.display = 'block';
}
