# Ecomail


- Synchronizace kontaktu do Ecomailu včetně custom fieldů
- Synchronizace SalesForce kampaní do Ecomailu. Kampani s příznakem se vytvoří subscriber list a nahrávají se do něj členové kampaně
- Synchronizace statistik kampaní z Ecomailu do SalesForcu
- ~~Synchronizace subscribers z Ecomailu do SalesForcu (jako nove leady) s omezením na seznam ze kterého se zakládají~~ (in progress)
- Možnost definice vlastních polí a jejich synchronizace
- Nedochází k mazání informací ani na jedné straně
- Možnost vypnout synchronizaci
## Instalace

Přes url: 

https://login.salesforce.com/packaging/installPackage.apexp?p0=04t09000000v1lQAAQ

nebo sfdx cli:

`sfdx force:package:install -p 04t09000000v1lQAAQ`


## Konfigurace po instalaci

1. Nastavení ecomailu
    1. Vytvořit záznam v Custom Metadata Type EcomailSetting, pojmenovat ho 'Main' a vyplnit všechny údaje. Vyplnit API key, list ids pro syspo nchronizace, povolit přes checkboxy které synchronizace mají probíhat.  Pole 'From email', 'Reply to' se používají pro vytváření seznamů kontaktu při synchronizaci kampaní
     - List ids jsou číselné id z ecomailu, možno vyčíst z url
    1. Pokud se mají přenášet jiné fieldy než standardní, vytvořit záznamy pro Custom Metadata Type EcomailFieldMapping. Funguje pouze pro fieldy na objektech Contact a Lead
1. Naschedulování jobů
    1. Otevřít Developer Console
    1. Spustit příkazy: 
    ```java
    System.schedule('Ecomail Campaigns Changed', '0 0 6,8,10,12,14,16,18,20 * * ?', new EcomailSyncCampaigns__Schedulable(false) );
    System.schedule('Ecomail Contacts Changed', '0 0 6,8,10,12,14,16,18,20 * * ?', new EcomailSyncContacts__Schedulable(false) );
    System.schedule('Ecomail Leads Changed', '0 0 6,8,10,12,14,16,18,20 * * ?', new EcomailSyncLeads__Schedulable(false) );

    System.schedule('Ecomail Campaigns All', '0 0 1 * * ?', new EcomailSyncCampaigns__Schedulable(true) );
    System.schedule('Ecomail Contacts All', '0 0 1 * * ?', new EcomailSyncContacts__Schedulable(true) );
    System.schedule('Ecomail Leads All', '0 0 1 * * ?', new EcomailSyncLeads__Schedulable(true) );
    ```

## Používání

- Synchronizují se jen kontakty, leady a kampaně s nadataveným fieldem EcomailSync__c na hodnotu true.
- Kampaně přenášejí všechny členy kampaně i když jejich hodnota EcomailSync__c je false.
- Synchronizace probíhá každé dvě hodiny mezi 6 - 20 hodinu.Pro změnu změnte skript výše. 
- Pro okamžitou synchronizace spusťte aplikaci Ecomail nebo přes Developer Console:
    - Pro synchronizaci kontaktů
        ```java
        EcomailContactSynchronizer synchronizer = new EcomailContactSynchronizer();
        synchronizer.syncAllContacts();
        ```
    - Pro synchronizaci leadů
        ```java
        EcomailContactSynchronizer synchronizer = new EcomailContactSynchronizer();
        synchronizer.syncAllLeads();
        ```
    - Pro synchronizaci kampaní
        ```java
        EcomailCampaignSynchronizer synchronizer = new EcomailCampaignSynchronizer();
        synchronizer.syncAllCampaigns();
        ```