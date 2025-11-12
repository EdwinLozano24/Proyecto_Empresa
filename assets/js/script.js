// Cambiar pestañas activas
document.querySelectorAll('.tab').forEach(tab => {
  tab.addEventListener('click', () => {
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    tab.classList.add('active');

    // Si deseas que cambie el contenido visible:
    const sectionId = tab.dataset.tab;
    document.querySelectorAll('main').forEach(sec => sec.style.display = 'none');
    document.getElementById(sectionId).style.display = 'block';
  });
});
