import Rails from '@rails/ujs';

const THEME_KEY = "theme";
const darkModeMedia = window.matchMedia('(prefers-color-scheme: dark)');

const setTheme = () => {
  // On page load or when changing themes, best to add inline in `head` to avoid FOUC
  if (localStorage.getItem(THEME_KEY) === 'dark' || (!(THEME_KEY in localStorage) && darkModeMedia.matches)) {
    document.documentElement.classList.add('dark');
  } else {
    document.documentElement.classList.remove('dark');
  }
}

// Detect when user changes their system level preference to set theme.
darkModeMedia.addEventListener("change", setTheme);

// When the page loads, set theme. By default, uses the system preference.
document.addEventListener("DOMContentLoaded", setTheme);

// If user deletes the Local Storage key, then re-apply theme.
window.addEventListener("storage", (event) => {
  if (event.key === THEME_KEY) {
    setTheme()
  }
});

const toggleTheme = () => {
  if (localStorage.getItem(THEME_KEY) === 'dark' || (!(THEME_KEY in localStorage) && darkModeMedia.matches)) {
    localStorage.setItem(THEME_KEY, 'light');
  } else {
    localStorage.setItem(THEME_KEY, 'dark');
  }
  setTheme();
};

Rails.delegate(document, ".dark-mode-toggle", "click", toggleTheme);
