(function () {

  const canvas = document.getElementById('stars');
  if (canvas) {
    const ctx = canvas.getContext('2d');


    function mulberry32(seed) {
      return function () {
        let t = (seed += 0x6d2b79f5);
        t = Math.imul(t ^ (t >>> 15), t | 1);
        t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
        return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
      };
    }
    const STAR_DENSITY = 0.00018;
    let stars = [];
    let dpr = 1;
    let builtW = 0;
    function build() {
      const w = window.innerWidth;
      const h = Math.max(window.innerHeight, window.screen?.height || 0);
      builtW = w;
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      canvas.width = w * dpr;
      canvas.height = h * dpr;
      canvas.style.width = w + 'px';
      canvas.style.height = h + 'px';
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      const count = Math.round(w * h * STAR_DENSITY);
      const r2 = mulberry32(1729);
      stars = [];
      for (let i = 0; i < count; i++) {
        const layer = r2() < 0.75 ? 0 : r2() < 0.85 ? 1 : 2;
        const size = layer === 0 ? 0.6 + r2() * 0.5
                   : layer === 1 ? 1.0 + r2() * 0.6
                                 : 1.4 + r2() * 0.7;
        const alpha = layer === 0 ? 0.35 + r2() * 0.25
                    : layer === 1 ? 0.55 + r2() * 0.25
                                  : 0.8 + r2() * 0.2;
        const color = r2() < 0.85
          ? `rgba(232,238,252,${alpha})`
          : `rgba(196,214,255,${alpha})`;
        stars.push({ x: r2() * w, y: r2() * h, r: size, color, glow: layer === 2 });
      }
      draw();
    }
    function draw() {
      ctx.clearRect(0, 0, canvas.width / dpr, canvas.height / dpr);
      for (const s of stars) {
        if (s.glow) {
          const g = ctx.createRadialGradient(s.x, s.y, 0, s.x, s.y, s.r * 4);
          g.addColorStop(0, s.color);
          g.addColorStop(1, 'rgba(0,0,0,0)');
          ctx.fillStyle = g;
          ctx.beginPath();
          ctx.arc(s.x, s.y, s.r * 4, 0, Math.PI * 2);
          ctx.fill();
        }
        ctx.fillStyle = s.color;
        ctx.beginPath();
        ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
        ctx.fill();
      }
    }
    let resizeTimer;
    window.addEventListener('resize', () => {
      if (window.innerWidth === builtW) return;
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(build, 150);
    });
    build();


    if ('IntersectionObserver' in window) {
      const io = new IntersectionObserver(
        (entries) => {
          for (const e of entries) {
            if (e.isIntersecting) {
              e.target.classList.add('in');
              io.unobserve(e.target);
            }
          }
        },
        { threshold: 0.12, rootMargin: '0px 0px -8% 0px' }
      );
      document.querySelectorAll('.hero, section h2, .prose, .contact-list, .project-hero, .project-body').forEach((el) => {
        el.classList.add('reveal');
        io.observe(el);
      });
    }
  }


  const links = document.querySelectorAll('.sky-link[data-star]');
  if (!links.length) return;
  for (const link of links) {
    const star = document.getElementById(link.dataset.star);
    if (!star) continue;
    const cx = star.getAttribute('cx');
    const cy = star.getAttribute('cy');
    const halo = [...document.querySelectorAll('.sky-stars .halo')].find(
      (h) => h.getAttribute('cx') === cx && h.getAttribute('cy') === cy
    );
    const on = () => { star.classList.add('active'); if (halo) halo.classList.add('active'); };
    const off = () => { star.classList.remove('active'); if (halo) halo.classList.remove('active'); };
    link.addEventListener('mouseenter', on);
    link.addEventListener('mouseleave', off);
    link.addEventListener('focus', on);
    link.addEventListener('blur', off);
  }
})();
