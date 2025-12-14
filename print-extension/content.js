// Override print settings when page loads
(function() {
  'use strict';

  // Inject CSS to remove margins and headers/footers
  const style = document.createElement('style');
  style.textContent = `
    @page {
      margin: 0 !important;
      size: auto;
    }
    @media print {
      body { margin: 0 !important; padding: 0 !important; }
      html { margin: 0 !important; padding: 0 !important; }
    }
  `;
  document.head.appendChild(style);

  // Listen for beforeprint event
  window.addEventListener('beforeprint', function() {
    // Additional print preparation if needed
    console.log('Print started - margins and headers disabled');
  });

  // Listen for afterprint event
  window.addEventListener('afterprint', function() {
    console.log('Print completed');
  });
})();
