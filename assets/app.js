(() => {
  "use strict";

  const API = window.USACO_TUTOR_API || "http://localhost:8787";
  const form = document.getElementById("submission-form");
  const submitCard = form.closest("section");
  let currentLesson = null;

  async function request(path, options = {}) {
    const response = await fetch(API + path, {
      ...options,
      headers: { "content-type": "application/json", ...(options.headers || {}) }
    });
    const data = await response.json().catch(() => ({ error: "Invalid server response" }));
    if (!response.ok) throw new Error(data.error || `Request failed (${response.status})`);
    return data;
  }

  function renderToday(day) {
    if (!day.lesson) {
      currentLesson = null;
      document.getElementById("day-status").textContent = "Waiting for the next verified lesson";
      document.getElementById("lesson-title").textContent = "Current learning position";
      document.getElementById("lesson-body").innerHTML = `
        <p>${escapeHtml(day.message)}</p>
        <p><strong>Last valid completed session:</strong> ${escapeHtml(day.current_position.last_valid_completed_session)}</p>
        <p><strong>Current target:</strong> rebuild sorting plus opposite-end two pointers independently.</p>
        <p><strong>Maximum next stage:</strong> ${escapeHtml(day.current_position.maximum_next_stage)}</p>`;
      submitCard.hidden = true;
      return;
    }

    currentLesson = day.lesson;
    submitCard.hidden = false;
    document.getElementById("day-status").textContent = day.day_status === "OPEN" ? "Learning day open" : "Learning day complete";
    document.getElementById("lesson-title").textContent = day.lesson.title;
    document.getElementById("lesson-body").innerHTML = `<p>${escapeHtml(day.lesson.instructions)}</p><p><strong>Required evidence:</strong> ${day.lesson.required_evidence.map(escapeHtml).join(", ")}</p>`;
  }

  function renderReview(review) {
    document.getElementById("review-card").hidden = false;
    document.getElementById("review-headline").textContent = review.headline;
    document.getElementById("review-explanation").textContent = review.explanation;
    document.getElementById("review-next-action").textContent = review.next_action;
    const support = document.getElementById("support-lesson");
    if (review.generated_lesson) {
      support.hidden = false;
      support.innerHTML = `<h3>${escapeHtml(review.generated_lesson.title)}</h3><p>${escapeHtml(review.generated_lesson.instructions)}</p>`;
    } else {
      support.hidden = true;
      support.textContent = "";
    }
    document.getElementById("day-status").textContent = review.day_status === "OPEN" ? "Learning day still open" : "Learning day complete";
  }

  function escapeHtml(value) {
    return String(value).replace(/[&<>'"]/g, char => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", "'": "&#39;", '"': "&quot;" })[char]);
  }

  form.addEventListener("submit", async event => {
    event.preventDefault();
    if (!currentLesson) return;
    const button = form.querySelector("button");
    const message = document.getElementById("form-message");
    button.disabled = true;
    message.textContent = "AI is checking the submission…";
    try {
      const result = await request("/api/submissions", {
        method: "POST",
        body: JSON.stringify({
          lesson_id: currentLesson.id,
          code: document.getElementById("code").value,
          explanation: document.getElementById("explanation").value,
          tests: document.getElementById("tests").value,
          judge_evidence: document.getElementById("judge-evidence").value
        })
      });
      renderReview(result.review);
      message.textContent = "Review saved.";
    } catch (error) {
      message.textContent = error.message;
    } finally {
      button.disabled = false;
    }
  });

  request("/api/today").then(renderToday).catch(error => {
    document.getElementById("day-status").textContent = "Could not load the learning state";
    document.getElementById("lesson-body").textContent = error.message;
    submitCard.hidden = true;
  });
})();
