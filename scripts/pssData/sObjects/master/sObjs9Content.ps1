 
$packageHash = @{}


$packageHash.add("contentDocument.cd", 
    @{fields        ="
 
    ArchivedById,
    ArchivedDate,
    ContentAssetId,
    ContentModifiedDate,
    ContentSize,
    CreatedById,
    CreatedDate,
    Description,
    FileExtension,
    FileType,
    Id,
    IsArchived,
    IsDeleted,
    LastModifiedById,
    LastModifiedDate,
    LastReferencedDate,
    LastViewedDate,
    LatestPublishedVersionId,
    OwnerId,
    ParentId,
    PublishStatus,
    SharingOption,
    SharingPrivacy,
    SystemModstamp,
    Title
 
    ";
        importOrder = "1";
        where       = " where  id != null ";
        externalId  = "Id";
        orderBy     = " SystemModstamp desc  limit 100 ";
         ignore      = $true
     
    } )





$packageHash.add("contentVersion.Ver", 
    @{fields        =
        " 
        SELECT
        Checksum,
        ContentBodyId,
        ContentDocumentId,
        ContentLocation,
        ContentModifiedById,
        ContentModifiedDate,
        ContentSize,
        ContentUrl,
        CreatedById,
        CreatedDate,
        CurrencyIsoCode,
        Description,
        ExternalDataSourceId,
        ExternalDocumentInfo1,
        ExternalDocumentInfo2,
        FeaturedContentBoost,
        FeaturedContentDate,
        FileExtension,
        FileType,
        FirstPublishLocationId,
        FirstPublishLocation.Type,
        FirstPublishLocation.Name,
        FirstPublishLocation.FirstName,
        FirstPublishLocation.LastName,
        Id,
        IsAssetEnabled,
        IsDeleted,
        IsEncrypted,
        IsLatest,
        IsMajorVersion,
        LastModifiedById,
        LastModifiedDate,
        LEXMAGICMOVER__LegacyNoteConvertedDate__c,
        LEXMAGICMOVER__LegacyNoteConvertedId__c,
        LEXMAGICMOVER__LegacyNoteConvertedLastModifiedDate__c,
        LEXMAGICMOVER__LegacyNoteConvertedLastModifiedDateTime__c,
        LEXMAGICMOVER__LegacyNoteConvertedOwnerId__c,
        LEXMAGICMOVER__LegacyNoteConvertedParentId__c,
        NegativeRatingCount,
        NetworkId,
        Origin,
        OwnerId,
        PathOnClient,
        PositiveRatingCount,
        PublishStatus,
        RatingCount,
        ReasonForChange,
        SharingOption,
        SharingPrivacy,
        SystemModstamp,
        TagCsv,
        Tech_Excel_Asset_ID__c,
        TextPreview,
        Title,
        VersionData,
        VersionNumber
    FROM
        ContentVersion
        
    ";
    importOrder = "1";
    where       = " where  id != null ";
    externalId  = "Id";
    orderBy     = " SystemModstamp desc  ";
     ignore      = $true
     
    } )



return $packageHash
 

