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
        console.log(count);
        console.log(element);
    } while (element == null && count < wait_count);
    
    return new Promise(resolve => { resolve(element) } );
}

// MARK: - TSDM
function registerTSDM() {
    if (!document.domain.includes('tsdm')) {
        return ;
    }
    
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
    let payButton = document.querySelector('div.locked a.viewpay');
    if (payButton !== null) {
        safari.extension.dispatchMessage('TSDM', {
            'uri': safari.extension.baseURI,
            'payable': true,
        });
    } else {
        // do nothing
    }
    
    // listen pay action
    safari.self.addEventListener("message", function(event) {
        // console.log(event.name);
        // console.log(event.message);
        if (event.name != "TSDM") {
            return ;
        }
      
        if (event.message.action == "pay") {
            payTSDM();
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

// MARK: - main
// The parent frame is the top-level frame, not an iframe.
// All non-iframe code goes before the closing brace.
if (window.top === window) {

    document.addEventListener('DOMContentLoaded', function(event) {
        console.log(safari.extension);
        
        // register components
        registerTSDM()
	});
    
    window.onunload = function(event) {
        safari.extension.dispatchMessage('SafraCrab', {
            'uri': safari.extension.baseURI
        });
    };
}
