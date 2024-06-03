import { Html5QrcodeScanner } from "html5-qrcode";
import { useEffect, useState } from "react";
import axios from 'axios';

function Scanqrcode() {
  const [scanResult, setScanResult] = useState(null);

  useEffect(() => {
    const scanner = new Html5QrcodeScanner("reader", {
      qrbox: {
        width: 250,
        height: 250,
      },
      fps: 5,
    });

    scanner.render(success, error);

    function success(result) {
      scanner.clear();
      setScanResult(result);

      // Make a POST request to your API endpoint
      axios.post('http://localhost:3002/dashscan', { id_register: result })
        .then(response => {
          // Display alert with the message from the response
          alert(response.data.message);
        })
        .catch(error => {
          // Handle error
          console.error('Error:', error);
          alert('An error occurred. Please try again.');
        });
    }

    function error(err) {
      console.warn(err);
    }
  }, []);

  return (
    <div className="App">
      {scanResult ? (
        <div>Success: <a href={'http://' + scanResult}>{scanResult}</a></div>
      ) : (
        <div id="reader"></div>
      )}
    </div>
  );
}

export default Scanqrcode;
