<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

 
 <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-dialog/dist/ax5dialog.css"/>
 <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-uploader/dist/ax5uploader.css"/>
 <link rel="stylesheet" type="text/css" href="/assets/plugins/bootstrap/dist/css/bootstrap.min.css"/>
 
 <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
<!-- Ionicons -->
<link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet"
 type="text/css" />

<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
<script src="https://cdn.rawgit.com/thomasJang/jquery-direct/master/dist/jquery-direct.min.js"></script>

<script type="text/javascript" src="/assets/plugins/ax5core/dist/ax5core.min.js"></script>
<script type="text/javascript" src="/assets/plugins/bootstrap/dist/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/assets/plugins/ax5ui-dialog/dist/ax5dialog.js"></script>
<script type="text/javascript" src="/assets/plugins/ax5ui-uploader/dist/ax5uploader.js"></script>




    
<div class="DH20"></div>
 
<div data-ax5uploader="upload1">
	<input type="hidden" name="targetId" value="111"/>
    <button data-ax5uploader-button="selector" class="btn btn-primary">Select File (*/*)</button>
    (Upload Max fileSize 20MB)
    <div data-uploaded-box="upload1" data-ax5uploader-uploaded-box="thumbnail"></div>
</div>
 
<div style="padding: 0;" data-btn-wrap>
    <h3>control</h3>
    <button class="btn btn-default" data-upload-btn="getUploadedFiles">getUploadedFiles</button>
    <button class="btn btn-default" data-upload-btn="removeFileAll">removeFileAll</button>
</div>


<script type="text/javascript">
    $(function () {
        var API_SERVER = "http://localhost";
        var DIALOG = new ax5.ui.dialog({
            title: "AX5UI"
        });
        var UPLOAD = new ax5.ui.uploader({
            //debug: true,
            target: $('[data-ax5uploader="upload1"]'),
            form: {
                action: API_SERVER + "/api/v1/ax5uploader/upload",
                fileName: "file"
            },
            multiple: true,
            manualUpload: false,
            progressBox: true,
            progressBoxDirection: "left",
            dropZone: {
                target: $('[data-uploaded-box="upload1"]')
            },
            uploadedBox: {
                target: $('[data-uploaded-box="upload1"]'),
                icon: {
                    "download": '<i class="fa fa-download" aria-hidden="true"></i>',
                    "delete": '<i class="fa fa-minus-circle" aria-hidden="true"></i>'
                },
                columnKeys: {
                    apiServerUrl: "http://localhost",
                    name: "fileNm",
                    type: "ext",
                    size: "fileSize",
                    uploadedName: "saveName",
                    thumbnail: "thumbnail"
                },
                lang: {
                    supportedHTML5_emptyListMsg: '<div class="text-center" style="padding-top: 30px;">Drop files here or click to upload.</div>',
                    emptyListMsg: '<div class="text-center" style="padding-top: 30px;">Empty of List.</div>'
                },
                onchange: function () {
 
                },
                onclick: function () {
                	
                	
                    // console.log(this.cellType);
                    var fileIndex = this.fileIndex;
                    var file = this.uploadedFiles[fileIndex];
                    switch (this.cellType) {
                        case "delete": UPLOAD.removeFile(fileIndex);
                      /*  DIALOG.confirm({
                                title: "AX5UI",
                                msg: "Are you sure you want to delete it?"
                            }, function () {
                                if (this.key == "ok") {
                                	
                                	
                                     $.ajax({
                                        contentType: "application/json",
                                        method: "post",
                                        url: API_SERVER + "/api/v1/ax5uploader/delete",
                                        data: JSON.stringify([{
                                            id: file.id
                                        }]),
                                        success: function (res) {
                                            if (res.error) {
                                                alert(res.error.message);
                                                return;
                                            }
                                            UPLOAD.removeFile(fileIndex);
                                        }
                                    }); 
                                }
                            }); */
                       
                            break;
 
                        case "download":
                            if (file.download) {
                                location.href = API_SERVER + file.download;
                            }
                            break;
                    }
                }
            },
            validateSelectedFiles: function () {
                console.log(this);
                // 10개 이상 업로드 되지 않도록 제한.
                if (this.uploadedFiles.length + this.selectedFiles.length > 10) {
                    alert("You can not upload more than 10 files.");
                    return false;
                }
 
                return true;
            },
            onprogress: function () {
 
            },
            onuploaderror: function () {
                console.log(this.error);
                DIALOG.alert(this.error.message);
            },
            onuploaded: function () {
 
            },
            onuploadComplete: function () {
 
            }
        });
 
        // 파일 목록 가져오기
        $.ajax({
            method: "GET",
            url: API_SERVER + "/api/v1/ax5uploader/list",
            success: function (res) {
 
                console.log("list get", res);
                UPLOAD.setUploadedFiles(res);
            }
        });
 
        // 컨트롤 버튼 이벤트 제어
        $('[data-btn-wrap]').clickAttr(this, "data-upload-btn", {
            "getUploadedFiles": function () {
                var files = ax5.util.deepCopy(UPLOAD.uploadedFiles);
                console.log(files);
                DIALOG.alert(JSON.stringify(files));
            },
            "removeFileAll": function () {
 
                DIALOG.confirm({
                    title: "AX5UI",
                    msg: "Are you sure you want to delete it?"
                }, function () {
 
                    if (this.key == "ok") {
 
                        var deleteFiles = [];
                        UPLOAD.uploadedFiles.forEach(function (f) {
                            deleteFiles.push({id: f.id});
                        });
 
                        $.ajax({
                            contentType: "application/json",
                            method: "post",
                            url: API_SERVER + "/api/v1/ax5uploader/delete",
                            data: JSON.stringify(deleteFiles),
                            success: function (res) {
                                if (res.error) {
                                    alert(res.error.message);
                                    return;
                                }
 
                                UPLOAD.removeFileAll();
                            }
                        });
 
                    }
                });
            }
        });
    });
</script>