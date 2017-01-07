//= require camaleon_cms/admin/_custom_fields
//= require camaleon_cms/admin/_i18n
//= require camaleon_cms/admin/_translator.js

//= require camaleon_cms/admin/uploader/uploader_manifest
//= require camaleon_cms/admin/jquery.validate
//= require_self
function modal_fix_multiple(){
    var activeModal = $('.modal.in:last', 'body').data('bs.modal');
    if (activeModal) {
        activeModal.$body.addClass('modal-open');
        activeModal.enforceFocus();
        activeModal.handleUpdate();
    }
}