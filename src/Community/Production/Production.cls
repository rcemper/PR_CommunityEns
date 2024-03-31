Class Community.Production.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Community.Production.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description>Production for community analytics</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <!-- Item Name="Служба загрузки пользователей" Category="" ClassName="Community.Production.UserService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="" -->
  <Item Name="User Load Service" Category="" ClassName="Community.Production.UserService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">dc</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="Query">SELECT
  users.uid                         AS UID,
  first_name.field_first_name_value AS FirstName,
  last_name.field_last_name_value   AS LastName,
  company.field_company_value       AS Company,
  title.field_title_position_value  AS Position,
  mail                              AS Email,
  FROM_UNIXTIME(created)            AS Created
FROM users
  LEFT OUTER JOIN field_data_field_last_name last_name ON last_name.entity_id = uid
  LEFT OUTER JOIN field_data_field_first_name first_name ON first_name.entity_id = uid
  LEFT OUTER JOIN field_data_field_company company ON company.entity_id = uid
  LEFT OUTER JOIN field_data_field_title_position title ON title.entity_id = uid</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Adapter" Name="CallInterval">7</Setting>
  </Item>
  <Item Name="EnsLib.JavaGateway.Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Port">55556</Setting>
  </Item>
  <!-- Item Name="Служба загрузки постов" Category="" ClassName="Community.Production.PostService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="" -->
  <Item Name="Post Download Service" Category="" ClassName="Community.Production.PostService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">dc</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Adapter" Name="Query">SELECT
 ref.entity_id                                                    AS Nid,
 title                                                            AS Name,
 FROM_UNIXTIME(node.created)                                      AS Created,
 node.uid                                                         AS Uid,
 GROUP_CONCAT(DISTINCT td.name)                                   AS Tags,
 ref.bundle                                                       AS Type,
 IFNULL(vc.cnt,0)                                                 AS Views,
 IFNULL(vv.avg,0)                                                 AS AvgVote,
 IFNULL(vv.amount,0)                                              AS VotesAmount,
 node.status                                                      AS Published,
 body.field_body_value                                            AS Text
FROM field_data_field_forum_ref AS ref
 LEFT OUTER JOIN node ON nid = entity_id
 LEFT OUTER JOIN (SELECT nid, COUNT(1) AS cnt
                  FROM nodeviewcount
                  GROUP BY nid) AS vc ON vc.nid = ref.entity_id
 LEFT OUTER JOIN taxonomy_index AS ti ON ti.nid = ref.entity_id
 LEFT OUTER JOIN taxonomy_term_data AS td ON td.tid = ti.tid
 LEFT OUTER JOIN field_data_field_body AS body ON node.nid = body.entity_id
 LEFT OUTER JOIN (SELECT entity_id AS nid, SUM(value) AS avg, COUNT(1) AS amount
                  FROM votingapi_vote
                  WHERE entity_type = 'node'
                  GROUP BY entity_id) AS vv ON vv.nid = ref.entity_id

GROUP BY ref.entity_id</Setting>
  </Item>
  <!-- Item Name="Проверка текста поста" Category="" ClassName="Community.Production.TextProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="" -->
  <Item Name="Check Post Text" Category="" ClassName="Community.Production.TextProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Words">data</Setting>
    <Setting Target="Host" Name="EmailOperation">Отправка почты</Setting>
  </Item>
  <!-- Item Name="Отправка почты" Category="" ClassName="Community.Production.EmailOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="" -->
  <Item Name="Send Mail" Category="" ClassName="Community.Production.EmailOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">Email</Setting>
    <Setting Target="Adapter" Name="SSLConfig">emailSSLConfiguration</Setting>
  </Item>
</Production>
}

}

