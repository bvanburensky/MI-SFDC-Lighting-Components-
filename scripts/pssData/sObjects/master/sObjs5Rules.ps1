
 
$packageHash = @{}

# if ref sum vars imput order > 2

#price Rules
#ignore conditions on insert
$packageHash.add("SBQQ__PriceRule__c.NoConditionsMet", 
    @{fields        = 
        "
    Unique_ID__c ,
    SBQQ__Product__r.Unique_ID__c , 
    Name ,
    SBQQ__Active__c,
    SBQQ__ConditionsMet__c,
    SBQQ__ConfiguratorEvaluationEvent__c,
    SBQQ__EvaluationEvent__c,
    SBQQ__EvaluationOrder__c,
    SBQQ__LookupObject__c,
    SBQQ__TargetObject__c,
    Description__c ";
        importOrder = "1";
        # where       = " where SBQQ__Active__c =true ";
       
    } )
#now set the conditions
$packageHash.add("SBQQ__PriceRule__c.WithConditionsMet", 
    @{fields        = 
        "Unique_ID__c ,
       SBQQ__Product__r.Unique_ID__c , 
       Name ,
       SBQQ__Active__c,
       SBQQ__AdvancedCondition__c,
       SBQQ__ConditionsMet__c,
       SBQQ__ConfiguratorEvaluationEvent__c,
       SBQQ__EvaluationEvent__c,
       SBQQ__EvaluationOrder__c,
       SBQQ__LookupObject__c,
       SBQQ__TargetObject__c,
       Description__c ";
        importOrder = "6";
        #  where       = " where SBQQ__Active__c =true ";
       
    } )

$packageHash.add("SBQQ__PriceCondition__c",
    @{fields        =
        " Unique_ID__c,
        SBQQ__Field__c,
        SBQQ__FilterFormula__c,
        SBQQ__FilterType__c,
        SBQQ__FilterVariable__r.Unique_ID__c,
        SBQQ__Index__c,
        SBQQ__Object__c,
        SBQQ__Operator__c,
  
        SBQQ__Rule__r.Unique_ID__c,
        SBQQ__TestedFormula__c,
        SBQQ__TestedVariable__r.Unique_ID__c,
        SBQQ__Value__c
    
   "; 
    
        importOrder = "4";
        # where       = " where SBQQ__ParentRuleIsActive__c =true " 
    } )

$packageHash.add("SBQQ__PriceAction__c",
    @{fields        =
        "
    Unique_ID__c,
    SBQQ__Field__c,
    SBQQ__Formula__c,
    SBQQ__Order__c,
    SBQQ__Rule__r.Unique_ID__c ,
    SBQQ__RuleLookupObject__c,
    SBQQ__SourceLookupField__c,
    SBQQ__SourceVariable__r.Unique_ID__c ,
    SBQQ__TargetObject__c,
    SBQQ__Value__c,
    SBQQ__ValueField__c

    ";

        importOrder = "4";
        #  where       = " where SBQQ__ParentRuleIsActive__c =true   "
    } )


# product Rules
$packageHash.add("SBQQ__ProductRule__c.NoConditionsMet",
    @{fields        =
        "  
    Unique_ID__c,
    Name,
    Description__c,
    SBQQ__Active__c,
    SBQQ__ConditionsMet__c,
    SBQQ__ErrorMessage__c,
    SBQQ__EvaluationEvent__c,
    SBQQ__EvaluationOrder__c,
    SBQQ__LookupMessageField__c,
    SBQQ__LookupObject__c,
    SBQQ__LookupProductField__c,
    SBQQ__LookupRequiredField__c,
    SBQQ__LookupTypeField__c,
    SBQQ__Scope__c,
    SBQQ__Type__c  ";
        importOrder = "1";
        #where       = " where SBQQ__Active__c =true   "
    } )  
$packageHash.add("SBQQ__ProductRule__c.WithConditionsMet",
    @{fields        =
        " 
    Unique_ID__c,
    Name,
    Description__c,
    SBQQ__Active__c,
    SBQQ__AdvancedCondition__c,
    SBQQ__ConditionsMet__c,
    SBQQ__ErrorMessage__c,
    SBQQ__EvaluationEvent__c,
    SBQQ__EvaluationOrder__c,
    SBQQ__LookupMessageField__c,
    SBQQ__LookupObject__c,
    SBQQ__LookupProductField__c,
    SBQQ__LookupRequiredField__c,
    SBQQ__LookupTypeField__c,
    SBQQ__Scope__c,
    SBQQ__Type__c  ";
        importOrder = "5";
     #   ignore = $true
        #   where       = " where SBQQ__Active__c =true   "
    } )

$packageHash.add("SBQQ__ProductAction__c", 
    @{fields        = "
        Unique_ID__c ,
        SBQQ__FilterField__c,
        SBQQ__FilterValue__c,
        SBQQ__Operator__c,
        SBQQ__Product__r.Unique_ID__c ,
        SBQQ__Required__c,
        SBQQ__Rule__r.Unique_ID__c ,
        SBQQ__Type__c,
        SBQQ__ValueAttribute__r.Unique_ID__c ,
        SBQQ__ValueField__c,
        SBQQ__ValueObject__c 


        ";
        importOrder = "4";
        # where       = " where SBQQ__ParentRuleIsActive__c =true "
    } )



$packageHash.add("SBQQ__ErrorCondition__c", 
    @{fields        = "
      Unique_ID__c,
      SBQQ__FilterType__c,
      SBQQ__FilterValue__c,
      SBQQ__FilterVariable__r.Unique_ID__c ,
      SBQQ__Index__c,
      SBQQ__Operator__c,
      SBQQ__Rule__r.Unique_ID__c,
      SBQQ__TestedAttribute__c,
      SBQQ__TestedField__c,
      SBQQ__TestedObject__c,
      SBQQ__TestedVariable__r.Unique_ID__c 
    ";
        importOrder = "4";
        #   where       = " where SBQQ__ParentRuleIsActive__c =true "
    } )
 
$packageHash.add("SBQQ__ConfigurationRule__c",
    @{fields        = "
    Unique_ID__c,
    SBQQ__Product__r.Unique_ID__c,
    SBQQ__ProductFeature__r.Unique_ID__c,
    SBQQ__ProductRule__r.Unique_ID__c, 
    SBQQ__Active__c,
    SBQQ__AscendingNestedLevel__c,
    SBQQ__DescendingActionNesting__c,
    SBQQ__DescendingNestedLevel__c";

        importOrder = "4";
        # where       = " where SBQQ__Product__r.isactive = true and SBQQ__ProductRule__r.SBQQ__Active__c = true"
    } )   

  
#,Unique_ID__c
$packageHash.add("SBQQ__LookupQuery__c",
    @{fields        = "
    Unique_ID__c,
    SBQQ__LookupField__c,
    SBQQ__MatchType__c,
    SBQQ__Operator__c,
    SBQQ__PriceRule2__r.Unique_ID__c,
    SBQQ__ProductRule__r.Unique_ID__c,
    SBQQ__RuleLookupObject__c,
    SBQQ__TestedConfigurationAttribute__r.Unique_ID__c,
    SBQQ__TestedField__c,
    SBQQ__TestedObject__c,
    SBQQ__TestedValue__c


   ";

        importOrder = "4";
        # where       = " where SBQQ__ParentRuleIsActive__c =true ";
       


    } )



    
return $packageHash
 

