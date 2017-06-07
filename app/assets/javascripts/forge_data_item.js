/*global $*/
var access_token,content_link,content_mime_type,content_file_name,content_thumbnail;

$(document).on('turbolinks:load', function() {
//$(document).ready(function() {

  //--- Handle download button
  if (content_link != "")
    $("a[data-download-content]").click(downloadContent);  // or .bind("click", function(e){
  else
    $("a[data-download-content]").hide();

  //--- Handle show upload form link
  $(".upload-form").hide();
  $("a[data-show-upload-form]").click(showUploadForm);

  //--- Show thumbnail in image
  if (content_thumbnail != null && content_thumbnail != "")
    showThumbnail();
});

function downloadContent(e) {
  e.preventDefault();
  $("a[data-download-content]").off("click");
  $("a[data-download-content]").text("Download Started ...");

  //SOURCE: https://www.html5rocks.com/en/tutorials/file/xhr2/
  // Create xhr object with responseType=blob (to get binary data from server) and send requestHeader for OAuth
  var xhr = new XMLHttpRequest();
  xhr.open('GET', content_link, true);
  xhr.responseType = 'blob';
  xhr.setRequestHeader("Authorization", "Bearer " + access_token);
  xhr.onload = function(e) {
    $("a[data-download-content]").on('click',downloadContent);
    $("a[data-download-content]").text("Download Completed")

    if (this.status == 200) {
      saveBlobAs(content_file_name, content_mime_type, this.response);
    }
  };
  xhr.onerror = function(e) {
    $("a[data-download-content]").on("click",downloadContent);
    $("a[data-download-content]").text("Download Failed!")
  };
  
  xhr.send();
}
  
function saveBlobAs (name, type, data) {
  //SOURCE: https://stackoverflow.com/questions/19327749/javascript-blob-filename-without-link

  // Create a blobUrl from data, create a hidden <a> (with download attr to set filename) and click on it to initiate download 
  if (data != null && navigator.msSaveBlob)
    return navigator.msSaveBlob(new Blob([data], { type: type }), name);
  var a = $("<a style='display: none;'/>");
  var blob = new Blob([data], {type: type});
  var url = window.URL.createObjectURL(blob);
  a.attr("href", url);
  a.attr("download", name);
  $("body").append(a);
  a[0].click();
  window.URL.revokeObjectURL(url);
  a.remove();
}

function showUploadForm(e) {
  e.preventDefault();
  $(".upload-form").toggle();
}

function showThumbnail () {
  //SOURCE: https://stackoverflow.com/questions/7650587/using-javascript-to-display-blob
  var xhr = new XMLHttpRequest();
  xhr.open("GET", content_thumbnail, true);
  xhr.responseType = "blob";
  xhr.setRequestHeader("Authorization", "Bearer " + access_token);
  
  xhr.onload = function(e) {
    if (this.status == 200) {
      var imageUrl = window.URL.createObjectURL(this.response);
      $("img[data-thumbnail]").attr("src",imageUrl);
    }
  };
  xhr.send();
}