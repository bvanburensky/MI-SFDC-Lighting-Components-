
# Objects about templates and quote terms
 
$packageHash = @{}

$packageHash.add("SBQQ__TemplateContent__c", 
    @{fields        = 
        "Unique_ID__c,
        SBQQ__CustomSource__c,
        SBQQ__FontFamily__c,
        SBQQ__FontSize__c,
        SBQQ__Markup__c,
        SBQQ__RawMarkup__c,
        SBQQ__TableStyle__c,
        SBQQ__TextColor__c,
        SBQQ__Type__c,
        Name";
        where  = "where Unique_ID__c like 'EX-20221113%'"  
        importOrder = "1"
     #   ignore      = $true
    } )

    
$packageHash.add("SBQQ__TemplateSection__c",
    @{fields        = "
    Unique_ID__c,
    Name,
    SBQQ__Template__r.Unique_ID__c,
    SBQQ__Content__r.Unique_ID__c ,
    SBQQ__BorderColor__c,
    SBQQ__BottomMargin__c,
    SBQQ__ColumnHeaderHidden__c,
    SBQQ__ConditionalPrintField__c,
    SBQQ__DisplayOrder__c,
    SBQQ__FilterField__c,
    SBQQ__FilterOperator__c,
    SBQQ__FilterValue__c,
    SBQQ__GroupField__c,
    SBQQ__KeepTogether__c,
    SBQQ__KeepWithNext__c,
    SBQQ__KeepWithPrevious__c,
    SBQQ__PageBreak__c,
    SBQQ__QuoteTotalsPrinted__c,
    SBQQ__RollUpField__c,
    SBQQ__SummaryDisplay__c,
    SBQQ__TopMargin__c";
        where  = "where Unique_ID__c in ('EX-20221113.01','EX-00000006') " ;
        importOrder = "3";
      #  ignore      = $true
    } )
 ## DELETE Auto created Existing lines after new template insert
$packageHash.add("SBQQ__LineColumn__c", 
    @{fields        = 
    " Unique_ID__c,
    Name,
    SBQQ__Template__r.Unique_ID__c ,
    SBQQ__Section__r.Unique_ID__c,
    SBQQ__Alignment__c,
    SBQQ__BottomMargin__c,
    SBQQ__ColumnHeadingField__c,
    SBQQ__ConditionalPrintField__c,
    SBQQ__DisplayOrder__c,
    SBQQ__DynamicNumberScale__c,
    SBQQ__FieldName__c,
    SBQQ__FontFamily__c,
    SBQQ__FontSize__c,
    SBQQ__FontWeight__c,
    SBQQ__HeadingTextColor__c,
    SBQQ__HideOnComponents__c,
    SBQQ__LeftMargin__c,
    SBQQ__RightMargin__c,
    SBQQ__RollUp__c,
    SBQQ__SeparateLine__c,
    SBQQ__SubGroupSummaryLabel__c,
    SBQQ__SummaryFontWeight__c,
    SBQQ__SummaryFunction__c,
    SBQQ__SummaryLabel__c,
    SBQQ__SummaryLevel__c,
    SBQQ__SummaryShadingColor__c,
    SBQQ__SummaryTextColor__c,
     SBQQ__TextColor__c,
    SBQQ__TopMargin__c,
    SBQQ__Width__c,
    SBQQ__WidthDiscardedWhenHidden__c    ";
        where = "where SBQQ__Section__r.Unique_ID__c in ('EX-20221113.01')"
        importOrder = "4"
       #ignore      = $true
    } )
    
  #, Section_Name__c 
  #, Term_Desc__c 
$packageHash.add("SBQQ__QuoteTerm__c.NoParent", 
    @{fields        = 
        "Unique_ID__c ,
        SBQQ__Active__c,

        SBQQ__ConditionsMet__c,
        SBQQ__Locked__c,
        SBQQ__PrintOrder__c,
        SBQQ__Quote__c,
        SBQQ__StandardTerm__c,
        SBQQ__Status__c,
        SBQQ__TemplateContent__r.Unique_ID__c, 
        SBQQ__Body__c
    ";
        where = "where Unique_ID__c in ('EX-QT-0055') ";
        importOrder = "1";
        ignore      = $true

    } )
    #after condition objects
$packageHash.add("SBQQ__QuoteTerm__c.Parent", 
    @{fields          = 
        "Unique_ID__c 
    , SBQQ__Active__c 
    , SBQQ__Locked__c 
    , SBQQ__ParentTerm__r.Unique_ID__c
    , SBQQ__PrintOrder__c 
    , SBQQ__Quote__c 
    , SBQQ__StandardTerm__c 
    , SBQQ__Status__c 
    , SBQQ__TemplateContent__r.Unique_ID__c 
    , SBQQ__Body__c 
    ";
       where = "where Unique_ID__c like 'EX-QT-xx%0001'";
        importOrder   = "2";
        ignore      = $true
    } )


$packageHash.add("SBQQ__TermCondition__c", 
    @{fields        = 
        " Unique_ID__c,
        SBQQ__Index__c,
        SBQQ__Operator__c,
        SBQQ__QuoteTerm__r.Unique_ID__c,
        SBQQ__TestedField__c,
        SBQQ__TestedVariable__r.Unique_ID__c,
        SBQQ__Value__c
     ";
        where = "where Unique_ID__c in ('EX-TC-00001','EX-TC-00002','EX-TC-00003','EX-TC-00004','EX-TC-00005','EX-TC-00006','EX-TC-00007','EX-TC-00008','EX-TC-00009','EX-TC-00010','EX-TC-00011','EX-TC-00012','EX-TC-00013','EX-TC-00014','EX-TC-00015','EX-TC-00016','EX-TC-00017','EX-TC-00018','EX-TC-00019','EX-TC-00020','EX-TC-00021','EX-TC-00022','EX-TC-00023','EX-TC-00024','EX-TC-00025','EX-TC-00026','EX-TC-00027','EX-TC-00028','EX-TC-00029','EX-TC-00030','EX-TC-00031','EX-TC-00032','EX-TC-00033')"
        importOrder = "4"
        ignore      = $true
    } )
# now that the conditions are loaded i can load the advanced condishions with out error
$packageHash.add("SBQQ__QuoteTerm__c.MetConditions", 
    @{fields        = 
        "Unique_ID__c
        ,SBQQ__AdvancedCondition__c 
        ,SBQQ__ConditionsMet__c   ";
        importOrder = "6";
        where       = " where SBQQ__AdvancedCondition__c = >'' "  ;
        ignore      = $true
    } )
    


  ## bloaway junk
    $packageHash.add("SBQQ__LineColumn__c.toDelete", 
    @{fields        = 
    "Unique_ID__c,
     id,
     name
     ";
         where       = " where Unique_ID__c = '' "  ;
        importOrder = "3"
        ignore      = $true  
    } )

    $packageHash.add("SBQQ__QuoteTemplate__c", 
    @{fields        = 
        " Unique_ID__c,
        SBQQ__HeaderContent__r.Unique_ID__c ,
        SBQQ__FooterContent__r.Unique_ID__c ,
        Name  ,
        SBQQ__AllPackageProductsShown__c,
        SBQQ__BillToTitle__c,
        SBQQ__BorderColor__c,
        SBQQ__BottomMargin__c,
        SBQQ__BundledProductsShown__c,
        SBQQ__CompanyCity__c,
        SBQQ__CompanyCountry__c,
        SBQQ__CompanyEmail__c,
        SBQQ__CompanyFax__c,
        SBQQ__CompanyName__c,
        SBQQ__CompanyPhone__c,
        SBQQ__CompanyPostalCode__c,
        SBQQ__CompanySlogan__c,
        SBQQ__CompanyState__c,
        SBQQ__CompanyStreet__c,
        SBQQ__ComponentProductsHidden__c,
        SBQQ__CustomerDiscountField__c,
        SBQQ__CustomerDiscountLabel__c,
        SBQQ__CustomerDiscountShown__c,
        SBQQ__Default__c,
        SBQQ__DeploymentStatus__c,
        SBQQ__DiscountScheduleShown__c,
        SBQQ__ExcludedPages__c,
        SBQQ__ExcludeHeaderFooter__c,
        SBQQ__FontFamily__c,
        SBQQ__FontSize__c,
        SBQQ__FooterHeight__c,
        SBQQ__GeneratorName__c,
        SBQQ__GrandTotalPrefix__c,
        SBQQ__GroupField__c,
        SBQQ__GroupFontFamily__c,
        SBQQ__GroupFontSize__c,
        SBQQ__GroupFontStyle__c,
        SBQQ__GroupGap__c,
        SBQQ__GroupShadingColor__c,
        SBQQ__GroupTextAlignment__c,
        SBQQ__GroupTextColor__c,
        SBQQ__HeaderHeight__c,
        SBQQ__HideGroupSubtotals__c,
        SBQQ__IntroductionTitle__c,
        SBQQ__LeftMargin__c,
        SBQQ__LineNumbering__c,
        SBQQ__LineSortField__c,

        SBQQ__NotesTitle__c,
        SBQQ__PageHeight__c,
        SBQQ__PageNumberAlignment__c,
        SBQQ__PageNumberPosition__c,
        SBQQ__PageNumberText__c,
        SBQQ__PageOrientation__c,
        SBQQ__PageWidth__c,
        SBQQ__PartnerDiscountLabel__c,
        SBQQ__PartnerDiscountShown__c,
        SBQQ__RenewedProductsShown__c,
        SBQQ__RightMargin__c,
        SBQQ__RollUpField__c,
        SBQQ__ShadingColor__c,
        SBQQ__ShipToTitle__c,
        SBQQ__SubGroupField__c,
        SBQQ__SubtotalField__c,
        SBQQ__SubtotalLabel__c,
        SBQQ__TermBodyIndent__c,
        SBQQ__TermsConditions__c,
        SBQQ__TermsConditionsTitle__c,
        SBQQ__TermsNumbered__c,
        SBQQ__TextColor__c,
        SBQQ__TopMargin__c,
        SBQQ__TotalField__c,
        SBQQ__TotalLabel__c,
        SBQQ__TotalsHidden__c,
        SBQQ__WatermarkId__c
 
        ";
        where  = "where Unique_ID__c in ('EX-00000001')"  
        importOrder = "2"
        ignore      = $true
    } )  

return $packageHash
 

