function make_req() {
    if (this.XMLHttpRequest) {
        return new XMLHttpRequest();
    }
    else {
        return new ActiveXObject("Microsoft.XMLHTTP");
    }
}

function show_comment_form(video_id) {
    var form_id = "commentForm" + video_id;
    var div_id = 'comment_form' + video_id;
    var div = document.getElementById(div_id);

    var form = document.createElement('form');
    form.action = "/";

    var input_text = document.createElement('input');
    input_text.id = form_id;
    input_text.type = "text";
    input_text.name = "comment";
    input_text.style.width = "500px";
    form.appendChild(input_text);

    var input = document.createElement('input');
    input.type = "submit";
    input.value = "送信";

    var input_dummy = document.createElement('input');
    input_dummy.style.position = "absolute";
    input_dummy.style.visibility = "hidden";
    form.appendChild(input_dummy);

    input.onclick = function() {
        var req = make_req();
        var formR = document.getElementById(form_id);
        var comment = encodeURIComponent(formR.value);

        req.onreadystatechange = function() {
            if (req.readyState == 4 && req.status == 200) {
                var response = req.responseText;
                var decoded = $.evalJSON(response);
                var result = (decoded["result"] == 1) ? '投稿したよ' : '一言が空だよ';
                alert(result);
            }
        };

        var action = '/api/create_comment';
        req.open("POST", action, true);
        req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        req.send('comment=' + comment + '&video_id=' + video_id);

        //$.get("/api/create_comment", {
        //    video_id: video_id,
        //    comment:  comment
        //});

        $("#" + div_id).hide();
        return false;
    };
    form.appendChild(input);
    div.appendChild(form);
}

function show_comment(video_id) {
    var div_id = 'comment_form' + video_id;
    var div = document.getElementById(div_id);

    $.getJSON("/api/get_comment", {video_id: video_id}, function(data) {
        var comments = data.result;
        $.each(comments, function() {
            put(div, this);
        });
    });
}

function put(elem, text) {
    var put_text = document.createTextNode(text);
    elem.appendChild(put_text);
    elem.appendChild(document.createElement('br'));
}
