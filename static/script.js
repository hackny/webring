---
---

const fellows = {{ site.data.fellows | jsonify }};

function goToRandom() {
  const randomFellow = fellows[Math.floor(Math.random() * fellows.length)];
  window.location = randomFellow.url;
};
