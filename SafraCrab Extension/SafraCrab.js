// MARK: - util

// sleep in milliseconds
function sleep(time) {
    return new Promise(resolve => { setTimeout(resolve, time) } );
}

// async try selector
async function aysncSelector(selector, time = 1000, wait_count = 5) {
    var element;
    var count = 0;
    do {
        await sleep(time, wait_count);
        element = document.querySelector(selector);
        count += 1;
        // console.log(count);
        // console.log(element.textContent);
    } while (element == null && count < wait_count);
    
    return new Promise(resolve => { resolve(element) } );
}

// MARK: - TSDM
function registerTSDM() {
    if (!document.domain.includes('tsdm')) {
        return ;
    }
    
    // init object
    safari.extension.dispatchMessage('TSDM', {
        'uri': safari.extension.baseURI
    });
    
    // get cost
    let locked = document.querySelector('div.locked');
    if (locked !== null) {
        var costNode = document.querySelector('div.locked > strong');
        if (costNode !== null) {
            var parsed = parseInt(costNode.textContent);
            if (!Number.isNaN(parsed)) {
                safari.extension.dispatchMessage('TSDM', {
                    'uri': safari.extension.baseURI,
                    'cost': parsed
                });
            }
        }
        
    } else {
        // do nothing
    }
    
    // get pay state
    let payButton = document.querySelector('div.locked');
    if (payButton !== null) {
        safari.extension.dispatchMessage('TSDM', {
            'uri': safari.extension.baseURI,
            'payable': true,
        });
    } else {
        // do nothing
    }
    
    // set listener
    safari.self.addEventListener("message", function(event) {
        if (event.name != "TSDM") {
            return ;
        }
      
        // listen pay action
        if (event.message.action == "pay") {
            payTSDM();
        }
        
        // listen check BaiduYun action
        if (event.message.action == "checkBaiduYun") {
            var targetContent = getPayContent();
            if (targetContent != null) {
                var links = getBaiduYunLinks(targetContent);
                var codes = getBaiduYunCodes(targetContent);
                
                safari.extension.dispatchMessage('TSDM', {
                    'uri': safari.extension.baseURI,
                    'baiduYunLinks': links,
                    'baiduYunCodes': codes
                });
            }
        }
    });
}

function payTSDM() {
    // trigger pay panel
    document.querySelector('a.viewpay').click();
    
    // wait pay panel
    aysncSelector('form#payform button.pnc', 3000, 10)
    .then(button => {
        // click pay button
        button.click();
        
        // wait reply panel (if exists)
        aysncSelector('div.locked:last-of-type a', 3000, 10)
        .then(replyButton => {
            if (replyButton != null) {
                // click reply button
                replyButton.click();
                
                // wait textarea
                return aysncSelector('#floatlayout_reply textarea')
                .then(textarea => {
                    // fulfill textarea
                    textarea.value = '感谢分享';
                    
                    // click reply
                    document.querySelector('#fwin_content_reply div#moreconf button').click();
                });
            }
        });    // end reply
    }); // end pay
}

function getPayContent() {
    if (document.querySelector('.showhide')) {
        return document.querySelector('.showhide');
    } else if (document.querySelector('.free-content')) {
        var content = document.querySelector('.free-content').parentNode.cloneNode(true);
        content.removeChild(content.querySelector('.free-content'));
        return content;
    } else {
        return null;
    }
}

// MARK: - BaiduYun

function getBaiduYunLinks(node) {
    // get links
    var baiduLinks = [], links = node.querySelectorAll('a');
    for (var i = 0; i < links.length; i++) {
        var href = links[i].href;
        if (href.startsWith('https://pan.baidu.com')) {
            baiduLinks.push(href);
        }
    }
    
    return baiduLinks;
}

function getBaiduYunCodes(node) {
    // get codes
    var codes = node.innerText.match(/([0-9a-zA-Z]{4}).*/gm).map(function(fullMatch) {
        if (fullMatch.trim().length == 4) {
            return fullMatch;
        } else {
            var match = fullMatch.match(/(?:Code|校验码|提取码)\W*([0-9a-zA-Z]{4})/i);
            if (match != null) {
                var code = match[1];
                return code;
            } else {
                return null;
            }
        }
    });
    return codes;
}

function registerBaiduYun() {
    if (document.domain != 'pan.baidu.com') {
        return ;
    }
    
    var searchParams = (new URL(document.location)).searchParams;
    var surl = searchParams.get('surl');
    
    // send trigger
    safari.extension.dispatchMessage('BaiduYun', {
        'uri': safari.extension.baseURI,
        'event': "DOMContentLoaded",
        'surl': surl,
    });
    
    // set listener
    safari.self.addEventListener("message", function(event) {
        if (event.name != "BaiduYun") {
            return ;
        }
        
        // listen fulfillCode action
        if (event.message.action == "fulfillCode") {
            var code = event.message.code;
            console.log(code);
            
            document.querySelector('form input').value = code;
            document.querySelector('form .input-area a').click();
        }
    });
}

// MARK: - Apple Developer

function registerAppleDeveloperDownload() {
    if (document.domain != 'developer.apple.com') {
        return ;
    }
    
    var releaseNote = {};
    
    // wait
    aysncSelector('h1.title', 3000, 10)
    .then(header => {
        var title = header.innerText;
        releaseNote.title = title;
    
        aysncSelector('div.primary-content > div.content', 3000, 10)
        .then(primaryContent => {
            var content = primaryContent.innerText;
            releaseNote.content = content;
            
            // send trigger
            safari.extension.dispatchMessage('AppleDeveloper', {
                'uri': safari.extension.baseURI,
                'event': "DOMContentLoaded",
                'title': releaseNote.title,
                'content': releaseNote.content,
            });
        });
    });

}

// MARK: - main
// The parent frame is the top-level frame, not an iframe.
// All non-iframe code goes before the closing brace.
if (window.top === window) {

    document.addEventListener('DOMContentLoaded', function(event) {
        console.log(safari.extension);
        
        // register components
        registerTSDM();
        registerBaiduYun();
        registerAppleDeveloperDownload();
	});
    
    window.onunload = function(event) {
        safari.extension.dispatchMessage('SafraCrab', {
            'uri': safari.extension.baseURI
        });
    };
}
