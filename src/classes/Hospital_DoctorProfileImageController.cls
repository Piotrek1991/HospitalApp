/**
 * Created by BRITENET on 17.12.2018.
 */

public with sharing class Hospital_DoctorProfileImageController {

    public Transient blob propFileBody { get; set; }
    public Transient string propFileName { get; set; }
    public Transient string propContentType { get; set; }
    public Integer fileSize { get; set; }
    public boolean doneuploading { get; set; }
    public boolean doneuploadingCroping { get; set; }
    public boolean uploadCroping { get; set; }
    public Transient string upldocUrl { get; set; }
    public Transient String inputdataUrl { get; set; }
    public String DocID { get; set; }
    public String recordId { get; set; }
    public String pageReferenceUrl { get; set; }
    public String firstNameLastName { get; set; }

    public Hospital_DoctorProfileImageController() {

        recordId = ApexPages.currentPage().getParameters().get('recordId');
        Doctor__c d = [SELECT Id, FirstNameLastName__c FROM Doctor__c WHERE Id = :recordId];
        firstNameLastName = String.format(Label.Upload_picture_title, new List<String>{
                d.FirstNameLastName__c
        });

        try {
            upldocUrl = '';
            inputdataUrl = '';
            uploadCroping = false;
            doneuploading = false;
            doneuploadingCroping = false;
        } catch (Exception ex) {
            Hospital_Utils.addToErrors(ex, 'Hospital_DoctorProfileImageController');

            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Unable_to_upload, new List<String>{
                    propFileName
            }));
            ApexPages.addMessage(msg);
        }
    }

    public Pagereference uploadPicture() {
        try {
            Transient User UserContactId;
            if (!uploadCroping)
                return EditProfilePic(); else
                    return uploadCrop();
        } catch (Exception ex) {
            Hospital_Utils.addToErrors(ex, 'Hospital_DoctorProfileImageController');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Unable_to_upload, new List<String>{
                    propFileName
            }));
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public Pagereference EditProfilePic() {
        try {
            system.debug('@@@@# propFileBody' + propFileBody + '' + propFileName + '' + propContentType + 'fsize' + fileSize + 'propFileName' + propFileName);
            if (fileSize > 2097152) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Unable_to_upload, new List<String>{
                        propFileName
                }));
                ApexPages.addMessage(msg);
            } else if ((propContentType != 'image/png') && (propContentType != 'image/jpeg')) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.File_Type_Not_Correct, new List<String>{
                }));
                ApexPages.addMessage(msg);
            } else {
                String strtemp = EncodingUtil.base64Encode(propFileBody);
                if (!String.isblank(strtemp))
                    upldocUrl = 'data:' + propContentType + ';base64,' + strtemp; else
                        upldocUrl = '';
                doneuploading = true;
            }
        } catch (Exception ex) {
            Hospital_Utils.addToErrors(ex, 'Hospital_DoctorProfileImageController');

            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Unable_to_upload, new List<String>{
                    propFileName
            }));
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public void checkIsEmpty() {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.YouDontSelectAFile, new List<String>{
        }));
    }

    public Pagereference uploadCrop() {
        List<String> datalist = inputdataUrl.split(',');
        if (datalist.size() > 0) {
            propContentType = datalist[0].split(';')[0];
            propContentType = propContentType.removeStart('data:');
            inputdataUrl = datalist[1].trim();
        }

        propFileBody = EncodingUtil.base64Decode(inputdataUrl);

        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :recordId AND name = :Label.Hospital_DefaultPicture];

        if (savedPicture.size() > 0) {
            delete savedPicture;
        }

        Attachment currentPicture = new Attachment(parentId = recordId, name = Label.Hospital_DefaultPicture, body = propFileBody);
        insert currentPicture;
        doneuploadingCroping = true;

        PageReference recordPageReference = Page.Hospital_DoctorView;
        recordPageReference.getParameters().put('id', recordId);
        recordPageReference.setRedirect(true);

        return recordPageReference;
    }
}