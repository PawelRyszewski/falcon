document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('newsletter-form');
  if (!form) return;
  form.addEventListener('submit', async function (e) {
    e.preventDefault();
    const formData = new FormData(form);
    const res = await fetch('/subscribe.php', { method: 'POST', body: formData });
    const text = await res.text();
    document.getElementById('newsletter-message').innerText = text;
    if (res.ok) form.reset();
  });
});
