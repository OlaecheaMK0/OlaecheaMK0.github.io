(function () {
  const links = document.querySelectorAll('.sky-link[data-star]');
  if (!links.length) return;

  // Bridge HTML hover/focus on each .sky-link to the matching SVG anchor star.
  // CSS `:has()` would work, but this is clearer and broader-supported.
  for (const link of links) {
    const id = link.dataset.star;
    const star = document.getElementById(id);
    if (!star) continue;

    // Find the halo sibling that shares coordinates with this anchor.
    const cx = star.getAttribute('cx');
    const cy = star.getAttribute('cy');
    const halo = [...document.querySelectorAll('.sky-stars .halo')].find(
      (h) => h.getAttribute('cx') === cx && h.getAttribute('cy') === cy
    );

    const activate = () => {
      star.classList.add('active');
      if (halo) halo.classList.add('active');
    };
    const deactivate = () => {
      star.classList.remove('active');
      if (halo) halo.classList.remove('active');
    };

    link.addEventListener('mouseenter', activate);
    link.addEventListener('mouseleave', deactivate);
    link.addEventListener('focus', activate);
    link.addEventListener('blur', deactivate);
  }
})();
