/*
** This class is a part of the KissAs3Fw actionscrip framework.
** See the header comment lines of the
** com . kisscodesystems . KissAs3Fw . Application
** The whole framework is available at:
** https://github.com/kisscodesystems/KissAs3Fw
** Demo applications:
** https://github.com/kisscodesystems/KissAs3Ds
**
** DESCRIPTION:
** ButtonFile.
** File browser and selector. Used for file uploads.
** in web context: the fileReference object will be used
** and the os file browse dialog will appear.
** in air context: the file object will be used
** and a customized list will appear to choose the file!
** If the file name to be selected does not meet the expectings
** then the empy file button (with no selected file) will be given.
**
** MAIN FEATURES:
** - Button. Label: "Browse" or the name of the selected file.
** - File filters can be specified.
** - Only the correctly formatted filenames will be accepted!
** - The upload is available by specifying a urlrequest object
** - Handles automatically the air or web environment!
**   (to use filereference or file)
** - File or Filereference can be set from outside
**   (for example after taking a photo by Camera object)
*/
package com . kisscodesystems . KissAs3Fw . ui
{
  import com . kisscodesystems . KissAs3Fw . Application ;
  import com . kisscodesystems . KissAs3Fw . ui . ListPanel ;
  import flash . events . DataEvent ;
  import flash . events . Event ;
  import flash . events . HTTPStatusEvent ;
  import flash . events . IOErrorEvent ;
  import flash . events . KeyboardEvent ;
  import flash . events . MouseEvent ;
  import flash . events . ProgressEvent ;
  import flash . events . SecurityErrorEvent ;
  import flash . filesystem . File ;
  import flash . net . FileFilter ;
  import flash . net . FileReference ;
  import flash . net . URLRequest ;
  import flash . ui . Keyboard ;
  public class ButtonFile extends ButtonText
  {
// This filereference object will be used.
    private var fileReference : FileReference = null ;
// Or the file will be used if possible.
    private var file : *= null ;
// If file is used then the browsing will happen in this.
    private var fileList : ListPanel = null ;
// The filefilters to apply to the browsing.
    private var fileFilters : Array = null ;
// Events of the success and failed uploadings.
    private var eventFileUploadDone : Event = null ;
    private var eventFileUploadFail : Event = null ;
    private var fileReferenceBrowseEvent : Event = null ;
    private var fileReferenceCancelEvent : Event = null ;
// Data recieved after successfully upload.
    private var uploadCompleteData : String = null ;
// The regexp to validate the name of the file.
    private var regexp : RegExp = null ;
// An event will be thrown if a file is selected.
    private var eventChanged : Event = null ;
// The predefined filefilters.
    public const fileFilterAll : FileFilter = new FileFilter ( "All Files (*.*)" , "*.*" ) ;
    public const fileFilterImgs : FileFilter = new FileFilter ( "Images (*.jpg, *.jpeg, *.gif, *.png, *.bmp)" , "*.jpg; *.jpeg; *.gif; *.png; *.bmp" ) ;
    public const fileFilterTxts : FileFilter = new FileFilter ( "Text Files (*.txt, *.rtf, *.log)" , "*.txt; *.rtf; *.log" ) ;
    public const fileFilterPdfs : FileFilter = new FileFilter ( "Pdf Files (*.pdf)" , "*.pdf" ) ;
    public const fileFilterDocs : FileFilter = new FileFilter ( "Document Files (*.doc, *.docx, *.odt)" , "*.doc; *.docx; *.odt" ) ;
    public const fileFilterPres : FileFilter = new FileFilter ( "Presentation Files (*.ppt, *.pptx, *.odp)" , "*.ppt; *.pptx; *.odp" ) ;
    public const fileFilterExcs : FileFilter = new FileFilter ( "Calculate Files (*.xls, *.xlsx, *.ods)" , "*.xls; *.xlsx; *.ods" ) ;
    public const fileFilterComs : FileFilter = new FileFilter ( "Compressed Files (*.zip, *.rar, *.tar, *.gz)" , "*.zip; *.rar; *.tar; *.gz" ) ;
/*
** The constructor doing the initialization of this object as usual.
*/
    public function ButtonFile ( applicationRef : Application ) : void
    {
// Super.
      super ( applicationRef ) ;
// The regexp to validate the filename.
      regexp = new RegExp ( application . getPropsApp ( ) . getRegexpStrFilename ( ) ) ;
// This is for default all file browsing. This can be replaced in setFileFilters.
      fileFilters = [ fileFilterAll ] ;
// The events to be dispatched at the right case.
      eventFileUploadDone = new Event ( application . EVENT_FILE_UPLOAD_DONE ) ;
      eventFileUploadFail = new Event ( application . EVENT_FILE_UPLOAD_FAIL ) ;
      fileReferenceBrowseEvent = new Event ( application . EVENT_FILE_REFERENCE_BROWSE ) ;
      fileReferenceCancelEvent = new Event ( application . EVENT_FILE_REFERENCE_CANCEL ) ;
      eventChanged = new Event ( application . EVENT_CHANGED ) ;
// Let's start with no filereference.
      destroyFileReference ( ) ;
// And a file icon.
      setIcon ( "file" ) ;
// And a sound type.
      setSoundTypeClick ( "button" ) ;
    }
/*
** Registering and unregistering the evnet listeners.
*/
    private function addEventListenersFileReference ( ) : void
    {
      if ( fileReference != null )
      {
        fileReference . addEventListener ( Event . SELECT , fileSelected ) ;
        fileReference . addEventListener ( Event . CANCEL , cancelHandler ) ;
        fileReference . addEventListener ( DataEvent . UPLOAD_COMPLETE_DATA , uploadDataRecived ) ;
        fileReference . addEventListener ( Event . OPEN , startHandler ) ;
        fileReference . addEventListener ( Event . COMPLETE , completeHandler ) ;
        fileReference . addEventListener ( HTTPStatusEvent . HTTP_STATUS , httpHandler ) ;
        fileReference . addEventListener ( ProgressEvent . PROGRESS , progressHandler ) ;
        fileReference . addEventListener ( IOErrorEvent . IO_ERROR , ioErrorHandler ) ;
        fileReference . addEventListener ( SecurityErrorEvent . SECURITY_ERROR , securityErrorHandler ) ;
      }
    }
    private function removeEventListenersFileReference ( ) : void
    {
      if ( fileReference != null )
      {
        fileReference . cancel ( ) ;
        fileReference . removeEventListener ( Event . SELECT , fileSelected ) ;
        fileReference . removeEventListener ( Event . CANCEL , cancelHandler ) ;
        fileReference . removeEventListener ( DataEvent . UPLOAD_COMPLETE_DATA , uploadDataRecived ) ;
        fileReference . removeEventListener ( Event . OPEN , startHandler ) ;
        fileReference . removeEventListener ( Event . COMPLETE , completeHandler ) ;
        fileReference . removeEventListener ( HTTPStatusEvent . HTTP_STATUS , httpHandler ) ;
        fileReference . removeEventListener ( ProgressEvent . PROGRESS , progressHandler ) ;
        fileReference . removeEventListener ( IOErrorEvent . IO_ERROR , ioErrorHandler ) ;
        fileReference . removeEventListener ( SecurityErrorEvent . SECURITY_ERROR , securityErrorHandler ) ;
      }
    }
    private function addEventListenersFile ( ) : void
    {
      if ( file != null )
      {
        file . addEventListener ( Event . SELECT , fileSelected ) ;
        file . addEventListener ( Event . CANCEL , cancelHandler ) ;
        file . addEventListener ( DataEvent . UPLOAD_COMPLETE_DATA , uploadDataRecived ) ;
        file . addEventListener ( Event . OPEN , startHandler ) ;
        file . addEventListener ( Event . COMPLETE , completeHandler ) ;
        file . addEventListener ( HTTPStatusEvent . HTTP_STATUS , httpHandler ) ;
        file . addEventListener ( ProgressEvent . PROGRESS , progressHandler ) ;
        file . addEventListener ( IOErrorEvent . IO_ERROR , ioErrorHandler ) ;
        file . addEventListener ( SecurityErrorEvent . SECURITY_ERROR , securityErrorHandler ) ;
      }
    }
    private function removeEventListenersFile ( ) : void
    {
      if ( file != null )
      {
        file . cancel ( ) ;
        file . removeEventListener ( Event . SELECT , fileSelected ) ;
        file . removeEventListener ( Event . CANCEL , cancelHandler ) ;
        file . removeEventListener ( DataEvent . UPLOAD_COMPLETE_DATA , uploadDataRecived ) ;
        file . removeEventListener ( Event . OPEN , startHandler ) ;
        file . removeEventListener ( Event . COMPLETE , completeHandler ) ;
        file . removeEventListener ( HTTPStatusEvent . HTTP_STATUS , httpHandler ) ;
        file . removeEventListener ( ProgressEvent . PROGRESS , progressHandler ) ;
        file . removeEventListener ( IOErrorEvent . IO_ERROR , ioErrorHandler ) ;
        file . removeEventListener ( SecurityErrorEvent . SECURITY_ERROR , securityErrorHandler ) ;
      }
    }
/*
** Gives the file or filereference from outside.
*/
    public function setFileReference ( f : * ) : void
    {
// Destroy if it is existing.
      destroyFileReference ( ) ;
      if ( application . getFileClassIsUsable ( ) )
      {
        try
        {
// The fileReference object to be initialized.
          file = File ( f ) ;
          if ( fileHasGoodExt ( file . name ) )
          {
// To specify the label of the file.
            addEventListenersFile ( ) ;
// The selection will happen automatically at this time.
            fileSelected ( null ) ;
          }
          else
          {
            destroyFileReference ( ) ;
          }
        }
        catch ( e : * )
        {
          destroyFileReference ( ) ;
        }
      }
      else
      {
        try
        {
// The fileReference object to be initialized.
          fileReference = FileReference ( f ) ;
          if ( fileHasGoodExt ( fileReference . name ) )
          {
// To specify the label of the file.
            addEventListenersFileReference ( ) ;
// The selection will happen automatically at this time.
            fileSelected ( null ) ;
          }
          else
          {
            destroyFileReference ( ) ;
          }
        }
        catch ( e : * )
        {
          destroyFileReference ( ) ;
        }
      }
    }
/*
** Destroys the existing fileReference object.
*/
    public function destroyFileReference ( ) : void
    {
      if ( application != null )
      {
// Let it be empty.
        uploadCompleteData = "" ;
// The label of this button is:
        if ( textLabel != null )
        {
          textLabel . setTextCode ( application . getTexts ( ) . SELECTED_FILE + application . getTexts ( ) . BROWSE ) ;
        }
// If it is not null then let it be null.
        if ( application . getFileClassIsUsable ( ) )
        {
          removeEventListenersFile ( ) ;
          file = null ;
        }
        else
        {
          removeEventListenersFileReference ( ) ;
          fileReference = null ;
        }
      }
    }
/*
** Gets the uploadCompleteData after the successful upload.
*/
    public function getUploadCompleteData ( ) : String
    {
      return uploadCompleteData ;
    }
/*
** Creates a new fileReference object.
*/
    public function createNewFileReference ( ) : void
    {
// Destroy if it is existing.
      destroyFileReference ( ) ;
      if ( application . getFileClassIsUsable ( ) )
      {
// The fileReference object to be initialized.
        file = new File ( ) ;
// To specify the label of the file.
        addEventListenersFile ( ) ;
      }
      else
      {
// The fileReference object to be initialized.
        fileReference = new FileReference ( ) ;
// To specify the label of the file.
        addEventListenersFileReference ( ) ;
      }
    }
/*
** The http status event listener.
*/
    protected function httpHandler ( e : HTTPStatusEvent ) : void { }
/*
** The file is selected.
*/
    private function fileSelected ( e : Event ) : void
    {
      if ( application . getFileClassIsUsable ( ) )
      {
        if ( regexp . test ( file . name ) )
        {
          textLabel . setTextCode ( application . getTexts ( ) . SELECTED_FILE + file . name ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
        }
        else
        {
          destroyFileReference ( ) ;
        }
      }
      else
      {
        if ( regexp . test ( fileReference . name ) )
        {
          textLabel . setTextCode ( application . getTexts ( ) . SELECTED_FILE + fileReference . name ) ;
          getBaseEventDispatcher ( ) . dispatchEvent ( eventChanged ) ;
        }
        else
        {
          destroyFileReference ( ) ;
        }
      }
    }
/*
** The file is loaded into flash ( not into the server )
*/
    private function completeHandler ( e : Event ) : void
    {
      if ( application . getFileClassIsUsable ( ) )
      {
        textLabel . setTextCode ( application . getTexts ( ) . UPLOADED_FILE + file . name ) ;
      }
      else
      {
        textLabel . setTextCode ( application . getTexts ( ) . UPLOADED_FILE + fileReference . name ) ;
      }
    }
/*
** Is there a file?
*/
    public function isFileSelected ( ) : Boolean
    {
      if ( application . getFileClassIsUsable ( ) )
      {
        return file != null ;
      }
      else
      {
        return fileReference != null ;
      }
    }
/*
** The upload is completed and data is recived from the server.
*/
    private function uploadDataRecived ( e : DataEvent ) : void
    {
      uploadCompleteData = e . data ;
      if ( getBaseEventDispatcher ( ) != null && eventFileUploadDone != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventFileUploadDone ) ;
      }
    }
/*
** When the file starts to be uploaded.
*/
    private function startHandler ( e : Event ) : void
    {
      setEnabled ( false ) ;
    }
/*
** Displaying the current upload state.
*/
    private function progressHandler ( e : ProgressEvent ) : void
    {
      textLabel . setTextCode ( application . getTexts ( ) . FILE_UPLOAD_IN_PROGRESS + ( Math . ceil ( ( e . bytesLoaded / e . bytesTotal ) * 100 ) ) + "%" ) ;
    }
/*
** Handling the IO error.
*/
    private function ioErrorHandler ( e : IOErrorEvent ) : void
    {
      uploadCompleteData = "" + e ;
      if ( getBaseEventDispatcher ( ) != null && eventFileUploadFail != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( eventFileUploadFail ) ;
      }
    }
/*
** Handling the Security error.
*/
    private function securityErrorHandler ( e : SecurityErrorEvent ) : void
    {
      destroyFileReference ( ) ;
    }
/*
** The user cancels the file selecting.
*/
    private function cancelHandler ( e : Event ) : void
    {
      destroyFileReference ( ) ;
      if ( getBaseEventDispatcher ( ) != null && eventFileUploadFail != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( fileReferenceCancelEvent ) ;
      }
    }
/*
** click + file browsing.
** open: clears the selected file if there were any.
*/
    override protected function baseWorkingButtonClick ( ) : void
    {
      super . baseWorkingButtonClick ( ) ;
      createNewFileReference ( ) ;
      setEnabled ( true ) ;
      if ( getBaseEventDispatcher ( ) != null )
      {
        getBaseEventDispatcher ( ) . dispatchEvent ( fileReferenceBrowseEvent ) ;
      }
      if ( application . getFileClassIsUsable ( ) )
      {
        createFileBrowse ( ) ;
      }
      else
      {
        fileReference . browse ( fileFilters ) ;
      }
    }
/*
** Creating the list of the files using File class.
*/
    private function createFileBrowse ( ) : void
    {
      if ( fileList == null )
      {
        fileList = new ListPanel ( application ) ;
        addChild ( fileList ) ;
        fileList . setsw ( getsw ( ) ) ;
        fileList . setCanBeEmpty ( false ) ;
        fileList . setNumOfElements ( application . getPropsApp ( ) . getFileBrowseMaxElements ( ) ) ;
        fileList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_CHANGED , fileListSelected ) ;
        fileList . getBaseEventDispatcher ( ) . addEventListener ( application . EVENT_SIZES_CHANGED , fileListSChanged ) ;
        selectDirectory ( File . documentsDirectory ) ;
        setBaseButtonVisible ( false ) ;
        if ( stage != null )
        {
          stage . addEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse , false , 0 , true ) ;
          stage . addEventListener ( KeyboardEvent . KEY_DOWN , hasToCloseByKeyboard , false , 0 , true ) ;
        }
      }
    }
/*
** Destroying the list of the files using File class.
*/
    private function destroyFileBrowse ( ) : void
    {
      if ( fileList != null )
      {
        if ( stage != null )
        {
          stage . removeEventListener ( MouseEvent . MOUSE_DOWN , hasToCloseByMouse ) ;
          stage . removeEventListener ( KeyboardEvent . KEY_DOWN , hasToCloseByKeyboard ) ;
        }
        fileList . destroy ( ) ;
        removeChild ( fileList ) ;
        fileList = null ;
        super . resize ( null ) ;
      }
      setBaseButtonVisible ( true ) ;
    }
/*
** This method will decide to close this object or not (by mouse).
*/
    protected function hasToCloseByMouse ( e : MouseEvent ) : void
    {
      if ( fileList != null )
      {
        if ( ! ( mouseX >= fileList . getcx ( ) && mouseX <= fileList . getcxsw ( ) && mouseY >= fileList . getcy ( ) && mouseY <= fileList . getcysh ( ) ) )
        {
          destroyFileBrowse ( ) ;
        }
      }
    }
/*
** This method will decide to close this object or not (by keyboard).
*/
    private function hasToCloseByKeyboard ( e : KeyboardEvent ) : void
    {
      if ( e . keyCode == Keyboard . TAB || e . keyCode == Keyboard . ESCAPE )
      {
        destroyFileBrowse ( ) ;
      }
    }
/*
** Selects a directory.
*/
    private function selectDirectory ( file : * ) : void
    {
      if ( File ( file ) != null )
      {
        if ( File ( file ) . isDirectory )
        {
          var arrLabels : Array = new Array ( ) ;
          var arrFiles : Array = new Array ( ) ;
          var arrIcons : Array = new Array ( ) ;
          var currentDirectoryContent : Array = File ( file ) . getDirectoryListing ( ) . sort ( fileSort ) ;
          arrLabels . push ( ".." ) ;
          arrFiles . push ( File ( file ) . parent ) ;
          arrIcons . push ( "leftarrow" ) ;
          for ( var i : int = 0 ; i < currentDirectoryContent . length ; i ++ )
          {
            if ( File ( currentDirectoryContent [ i ] ) . isDirectory )
            {
              arrLabels . push ( "+" + currentDirectoryContent [ i ] . name ) ;
              arrFiles . push ( File ( currentDirectoryContent [ i ] ) ) ;
              arrIcons . push ( "folder" ) ;
            }
            else if ( fileHasGoodExt ( currentDirectoryContent [ i ] . name ) )
            {
              arrLabels . push ( "  " + currentDirectoryContent [ i ] . name ) ;
              arrFiles . push ( File ( currentDirectoryContent [ i ] ) ) ;
              arrIcons . push ( "file" ) ;
            }
          }
          fileList . setArrays ( arrLabels , arrFiles , arrIcons ) ;
        }
      }
    }
/*
** The filename has a good or bad extension.
*/
    private function fileHasGoodExt ( filename : String ) : Boolean
    {
      var fileMatchesToFilteredExtensions : Boolean = false ;
      var currentFileFilterExtensions : String = "" ;
      var currentFileExtPoint : int = filename . lastIndexOf ( "." ) ;
      var currentFileExtension : String = filename . substr ( currentFileExtPoint + 1 ) . toLowerCase ( ) ;
      if ( fileFilters != null )
      {
        for ( var j : int = 0 ; j < fileFilters . length ; j ++ )
        {
          currentFileFilterExtensions = FileFilter ( fileFilters [ j ] ) . extension . toLowerCase ( ) + ";" ;
          if ( currentFileFilterExtensions . indexOf ( ".*" ) != - 1 )
          {
            fileMatchesToFilteredExtensions = true ;
            break ;
          }
          else
          {
            if ( currentFileExtPoint > 0 )
            {
              if ( currentFileFilterExtensions . indexOf ( "." + currentFileExtension + ";" ) > 0 )
              {
                fileMatchesToFilteredExtensions = true ;
                break ;
              }
            }
          }
        }
      }
      else
      {
        fileMatchesToFilteredExtensions = true ;
      }
      return fileMatchesToFilteredExtensions ;
    }
/*
** Sorts the names of the object located in the directory.
*/
    private function fileSort ( file1 : * , file2 : * ) : int
    {
      if ( File ( file1 ) . isDirectory && ! File ( file2 ) . isDirectory )
      {
        return - 1 ;
      }
      else if ( ! File ( file1 ) . isDirectory && File ( file2 ) . isDirectory )
      {
        return 1 ;
      }
      else
      {
        return File ( file1 ) . name . localeCompare ( File ( file2 ) . name ) ;
      }
    }
/*
** The file or directory has been selected in the fileList.
*/
    private function fileListSelected ( e : Event ) : void
    {
      var f : File = fileList . getArrayValues ( ) [ fileList . getSelectedIndexes ( ) [ 0 ] ] ;
      if ( f . isDirectory )
      {
        selectDirectory ( f ) ;
      }
      else
      {
        file = f ;
        destroyFileBrowse ( ) ;
        fileSelected ( null ) ;
      }
    }
/*
** The size of the list has been changed.
*/
    private function fileListSChanged ( e : Event ) : void
    {
      if ( fileList != null )
      {
        setswh ( fileList . getsw ( ) , fileList . getsh ( ) ) ;
      }
      toBeVisible ( ) ;
    }
/*
** Sets the fileFileter array.
*/
    public function setFileFilters ( f : Array ) : void
    {
      fileFilters = f ;
    }
/*
** Use this method when uploading a file.
*/
    public function upload ( urlRequest : URLRequest ) : void
    {
      if ( application . getFileClassIsUsable ( ) )
      {
        if ( urlRequest != null && file != null )
        {
          file . upload ( urlRequest ) ;
        }
      }
      else
      {
        if ( urlRequest != null && fileReference != null )
        {
          fileReference . upload ( urlRequest ) ;
        }
      }
    }
/*
** Sets the label of the button.
** (has to be empty, textLabel . setTextCode will be used inside. )
*/
    override public function setTextCode ( newTextCode : String ) : void { }
/*
** Overriding this destroy method.
*/
    override public function destroy ( ) : void
    {
// 1: unregister every event listeners added to different than local_var . getBaseEventDispatcher ( )
      removeEventListenersFile ( ) ;
      removeEventListenersFileReference ( ) ;
// 2: stopimmediatepropagation, bitmapdata dispose, array splice ( 0 ), etc.
      fileFilters . splice ( 0 ) ;
      if ( eventFileUploadDone != null )
      {
        eventFileUploadDone . stopImmediatePropagation ( ) ;
      }
      if ( eventFileUploadFail != null )
      {
        eventFileUploadFail . stopImmediatePropagation ( ) ;
      }
      if ( fileReferenceBrowseEvent != null )
      {
        fileReferenceBrowseEvent . stopImmediatePropagation ( ) ;
      }
      if ( fileReferenceCancelEvent != null )
      {
        fileReferenceCancelEvent . stopImmediatePropagation ( ) ;
      }
      if ( eventChanged != null )
      {
        eventChanged . stopImmediatePropagation ( ) ;
      }
// 3: calling the super destroy.
      super . destroy ( ) ;
// 4: every reference and value should be resetted to null, 0 or false.
      fileReference = null ;
      file = null ;
      fileList = null ;
      fileFilters = null ;
      eventFileUploadDone = null ;
      eventFileUploadFail = null ;
      fileReferenceBrowseEvent = null ;
      fileReferenceCancelEvent = null ;
      eventChanged = null ;
      uploadCompleteData = null ;
      regexp = null ;
    }
  }
}
