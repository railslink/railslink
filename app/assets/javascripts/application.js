import "timezones";

(function () {
  document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("new_slack_membership_submission");
    if (form) {
      const fax = form.getElementsByClassName("fax")[0];
      fax.parentNode.removeChild(fax);
    }

    Array.from(document.getElementsByClassName("button")).forEach(function (
      button
    ) {
      const logo = document.getElementById("logo");
      if (!logo) return;
      button.addEventListener("click", function (event) {
        logo.className += " spin";
      });
    });

    var burger = document.querySelector(".navbar-burger");
    if (burger) {
      var menu = document.querySelector(".navbar-menu");
      burger.addEventListener("click", function () {
        burger.classList.toggle("is-active");
        menu.classList.toggle("is-active");
      });
    }
  });
}).call(this);
