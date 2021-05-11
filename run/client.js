// get DOM elements


var dataChannelLog = document.getElementById('data-channel'),
    iceConnectionLog = document.getElementById('ice-connection-state'),
    iceGatheringLog = document.getElementById('ice-gathering-state'),
    signalingLog = document.getElementById('signaling-state');

    prueba       = document.querySelector("#videoElement")
    const snap = document.getElementById("snap");
    const send_b = document.getElementById("send_b")
    const canvas = document.querySelector("#canvas");
    
    
 
// peer connection
var pc = null;

// data channel
var dc = null, dcInterval = null,  dataConstraint = null; 

function createPeerConnection() {
    var config = {
        sdpSemantics: 'unified-plan'
    };

    pc = new RTCPeerConnection(config);
    sendChannel = pc.createDataChannel('sendDataChannel',dataConstraint);
   

    // register some listeners to help debugging
    pc.addEventListener('icegatheringstatechange', function() {
        iceGatheringLog.textContent += ' -> ' + pc.iceGatheringState;
    }, false);
    iceGatheringLog.textContent = pc.iceGatheringState;

    pc.addEventListener('iceconnectionstatechange', function() {
        iceConnectionLog.textContent += ' -> ' + pc.iceConnectionState;
    }, false);
    iceConnectionLog.textContent = pc.iceConnectionState;

    pc.addEventListener('signalingstatechange', function() {
        signalingLog.textContent += ' -> ' + pc.signalingState;
    }, false);
    signalingLog.textContent = pc.signalingState;

    // connect audio / video
    pc.addEventListener('track', function(evt) {
        document.getElementById('video').srcObject = evt.streams[0];
    });

    return pc;
}

function negotiate() {
    return pc.createOffer().then(function(offer) {
        return pc.setLocalDescription(offer);
    }).then(function() {
        // wait for ICE gathering to complete
        return new Promise(function(resolve) {
            if (pc.iceGatheringState === 'complete') {
                resolve();
            } else {
                function checkState() {
                    if (pc.iceGatheringState === 'complete') {
                        pc.removeEventListener('icegatheringstatechange', checkState);
                        resolve();
                    }
                }
                pc.addEventListener('icegatheringstatechange', checkState);
            }
        });
    }).then(function() {
        var offer = pc.localDescription;
        var codec;

        codec = document.getElementById('video-codec').value;
        if (codec !== 'default') {
            offer.sdp = sdpFilterCodec('video', codec, offer.sdp);
        }

        document.getElementById('offer-sdp').textContent = offer.sdp;
        return fetch('/offer', {
            body: JSON.stringify({
                sdp: offer.sdp,
                type: offer.type,
                width_height: document.getElementById('video-resolution').value,
                kernel_ref: document.getElementById('kernelRef').value

            }),
            headers: {
                'Content-Type': 'application/json'
            },
            method: 'POST'
        });
    }).then(function(response) {
        return response.json();
    }).then(function(answer) {
        document.getElementById('answer-sdp').textContent = answer.sdp;
        return pc.setRemoteDescription(answer);
    }).catch(function(e) {
        alert(e);
    });
}

function getDevices() {
    return navigator.mediaDevices.enumerateDevices();
}


function start(){

    document.getElementById('stop').disabled = false;
    document.getElementById('start').disabled = true;

    document.getElementById('start').style.display = 'inline';

    var video1 = document.querySelector("#videoElement");

    pc = createPeerConnection();

    var time_start = null;

    function current_stamp() {
        if (time_start === null) {
            time_start = new Date().getTime();
            return 0;
        } else {
            return new Date().getTime() - time_start;
        }
    }

    var constraints = {
        video: false
    };

    var resolution = document.getElementById('video-resolution').value;
    if (resolution) {
        resolution = resolution.split('x');
        constraints.video = {
            width: parseInt(resolution[0], 0),
            height: parseInt(resolution[1], 0)
        };
    } else {
        constraints.video = true;
    }

    navigator.mediaDevices.getUserMedia(constraints)
        .then(function (stream) {
            video1.srcObject = stream;
            
            prueba.srcObject  = stream;
        })
    .catch(function (error) {
      console.log("Something went wrong!");
    });

    if (constraints.video) {
        if (constraints.video) {
            document.getElementById('media').style.display = 'block';
        }
        navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
            stream.getTracks().forEach(function(track) {
                pc.addTrack(track, stream);
                
            });
            return negotiate();
        }, function(err) {
            alert('Could not acquire media: ' + err);
        });
    } else {
        negotiate();
    }

    document.getElementById('stop').style.display = 'inline-block';
}




// function    send_photo(){  NO HACE NADA AUN

//     //pc = createPeerConnection()
//     var data = "HolaPrueba";
//     sendChannel.send(data);
//     trace('Sent Data: ' + data);
// }

// logging utility . Sirve para agregar comentarios en la consola web (apretar F12  en la web y luego consola)
function trace(arg) {
    var now = (window.performance.now() / 1000).toFixed(3);
    console.log(now + ': ', arg);
}


function stop() {

    document.getElementById('stop').disabled = true;
    document.getElementById('start').disabled = false;

    document.getElementById('stop').style.display = 'inline';

    var video1 = document.querySelector("#videoElement");

    var stream = video1.srcObject;
    if(stream){
        var tracks = stream.getTracks();

        for (var i = 0; i < tracks.length; i++) {
            var track = tracks[i];
        track.stop();
       }

        video1.srcObject = null;
    }

    // close data channel
    if (dc) {
        dc.close();
    }

    // close transceivers
    if (pc.getTransceivers) {
        pc.getTransceivers().forEach(function(transceiver) {
            if (transceiver.stop) {
                transceiver.stop();
            }
        });
    }

    // close local audio / video
    pc.getSenders().forEach(function(sender) {
        sender.track.stop();
    });

    // close peer connection
    setTimeout(function() {
        pc.close();
    }, 500);
}








function sdpFilterCodec(kind, codec, realSdp) {
    var allowed = []
    var rtxRegex = new RegExp('a=fmtp:(\\d+) apt=(\\d+)\r$');
    var codecRegex = new RegExp('a=rtpmap:([0-9]+) ' + escapeRegExp(codec))
    var videoRegex = new RegExp('(m=' + kind + ' .*?)( ([0-9]+))*\\s*$')
    
    var lines = realSdp.split('\n');

    var isKind = false;
    for (var i = 0; i < lines.length; i++) {
        if (lines[i].startsWith('m=' + kind + ' ')) {
            isKind = true;
        } else if (lines[i].startsWith('m=')) {
            isKind = false;
        }

        if (isKind) {
            var match = lines[i].match(codecRegex);
            if (match) {
                allowed.push(parseInt(match[1]));
            }

            match = lines[i].match(rtxRegex);
            if (match && allowed.includes(parseInt(match[2]))) {
                allowed.push(parseInt(match[1]));
            }
        }
    }

    var skipRegex = 'a=(fmtp|rtcp-fb|rtpmap):([0-9]+)';
    var sdp = '';

    isKind = false;
    for (var i = 0; i < lines.length; i++) {
        if (lines[i].startsWith('m=' + kind + ' ')) {
            isKind = true;
        } else if (lines[i].startsWith('m=')) {
            isKind = false;
        }

        if (isKind) {
            var skipMatch = lines[i].match(skipRegex);
            if (skipMatch && !allowed.includes(parseInt(skipMatch[2]))) {
                continue;
            } else if (lines[i].match(videoRegex)) {
                sdp += lines[i].replace(videoRegex, '$1 ' + allowed.join(' ')) + '\n';
            } else {
                sdp += lines[i] + '\n';
            }
        } else {
            sdp += lines[i] + '\n';
        }
    }

    return sdp;
}

function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}


var conn = new rtcbot.RTCConnection();
// conn.subscribe(m => console.log("Received from python:", m));




conn.subscribe(m => recepcion(m));
// console.log(contenido)

function recepcion(mensaje)
{
    
    console.log(mensaje);
    console.log(JSON.parse(mensaje).im_url);

    imAfterUART = document.getElementById("imAfterUART");
    // var link='';
    // link=(JSON.parse(mensaje)).im_url;
    imAfterUART.src=(JSON.parse(mensaje)).im_url;
    trace("Imagen Procesada Recibida");

}

async function connect() { //establece la conexion para mandar mensajes
    let offer = await conn.getLocalDescription();

    // POST the information to /connect
    let response = await fetch("/connect", {
        method: "POST",
        cache: "no-cache",
        body: JSON.stringify(offer)
    });

    await conn.setRemoteDescription(await response.json());

    trace("Ready!");
    
}

connect();

// agregar tantos botones como flags se requieran
//estas funciones reciben un mensaje apretado
var mybutton = document.querySelector("#mybutton");
mybutton.onclick = function() {

    imAfterUART=document.getElementById("imAfterUART");
    imAfterUART.src="https://static.wixstatic.com/media/c6abac_72b300c91c794879a85fc3f8fd46ed63~mv2.gif"
    conn.put_nowait("send_photo");
    trace("Enviando")
    
};




function take_photo() 
{ //permite sacar fotos que se muestra en el sitio web

    // const DataURI = myCanvas
    var context = canvas.getContext('2d');
    imAfterUART=document.getElementById("imAfterUART");
    imAfterUART.src="https://static.wixstatic.com/media/c6abac_72b300c91c794879a85fc3f8fd46ed63~mv2.gif"


    var sourceX = 300;
    var sourceY = 220;
    var sourceWidth = 40;
    var sourceHeight = 40;
    var destWidth = 400;
    var destHeight = 400;
    var destX = canvas.width / 2 - destWidth / 2;
    var destY = canvas.height / 2 - destHeight / 2;

    context.drawImage(prueba, sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);
      
    // context.drawImage(prueba, 0, 0, 640, 480);
    
    conn.put_nowait("take_photo");
    trace("Capturando Foto");
}



ctx = canvas.getContext('2d');
const image = new Image();
image.src = 'https://wallpaperaccess.com/full/481675.jpg';
image.onload = () => {
    ctx.imageSmoothingEnabled = false;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(image, 0, 0,640,480);
};
    
   
