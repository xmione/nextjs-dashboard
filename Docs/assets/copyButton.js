document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('pre > code').forEach(function(codeBlock) {
      var button = document.createElement('button');
      button.className = 'copy-button';
      button.type = 'button';
      button.innerText = 'Copy';
      
      button.addEventListener('click', function() {
        navigator.clipboard.writeText(codeBlock.innerText).then(function() {
          button.blur();
          button.innerText = 'Copied!';
          setTimeout(function() {
            button.innerText = 'Copy';
          }, 2000);
        }, function(error) {
          button.innerText = 'Error';
        });
      });
  
      var pre = codeBlock.parentNode;
      pre.style.position = 'relative';
      pre.insertBefore(button, codeBlock);
    });
  });
  