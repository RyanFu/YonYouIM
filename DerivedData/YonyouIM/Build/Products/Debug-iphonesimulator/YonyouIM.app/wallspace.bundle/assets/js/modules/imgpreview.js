function onUploadImgChange(sender, id){
    var filePath = sender.value;
    var fileExt = filePath.substring(filePath.lastIndexOf(".")).toLowerCase();
    if(typeof(id) == 'undefined')id = 'preview';
    var objPreview = document.getElementById( id ),
        objPreviewFake = document.getElementById( id + '_fake' ),
        objPreviewSizeFake = document.getElementById( id + '_size_fake' );
    try{
        if(typeof FileReader !== 'undefined'){
            var file = sender.files[0];
            var fileSize = file.fileSize || file.size;
//          if(checkFileSize(fileSize)){
                var reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = function(e){
                    objPreview.src = this.result;
                };
//          }
        }
    }catch(e){
        ("出错了");
    }
}
//检测文件大小
function checkFileSize(fileSize){
//  if(fileSize > 1024*1024*5){
//      alert("您上传的文件大于5M,请重新选择！");
//      return false;
//  }
    return true;
}
