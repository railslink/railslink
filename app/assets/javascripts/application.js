// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree .

(function() {
  document.addEventListener("DOMContentLoaded", function() {

    const form = document.getElementById("new_slack_membership_submission");
    if ( form ) {
      const fax = form.getElementsByClassName("fax")[0];
      fax.parentNode.removeChild(fax);
    }

    Array.from(document.getElementsByClassName('button')).forEach(function(button) {
      const logo = document.getElementById('logo');
      if ( !logo ) return;
      button.addEventListener("click", function( event ) {
        logo.className += " spin";
      });
    });

    var burger = document.querySelector('.navbar-burger');
    if ( burger ) {
      var menu = document.querySelector('.navbar-menu');
      burger.addEventListener('click', function() {
        burger.classList.toggle('is-active');
        menu.classList.toggle('is-active');
      });
    }
  });
}).call(this);
