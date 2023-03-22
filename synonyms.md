# Elasticsearch Synonyms Word
Synonyms = "คำเหมือน หรือคำศัพท์คำหนึ่งที่มีความหมายเหมือนกันกับอีกคำหนึ่ง แต่สะกดไม่เหมือนกัน"
โจทย์ของเราก็คือ 
หมา, สุนัข  
shower, อาบน้ำ  
ยูเซอริน, Eucerin

ถ้าเป็น use case english  
case 1: (like British English “lift” vs. American English “elevator”)  
case 2: in ecommerce search (“iPod” vs. “i-Pod”)

elasticsearch => Synonyms filters (custom analyzer)  
ข้อสังเกต  
1. The index might get bigger, because all synonyms must be indexed.  
2. Search scoring จะถูกนับด้วยอาจจะต้องจูนกันใหม่  
3. Synonym rules can’t be changed for existing documents without reindexing.



# workthought

## 1. init tempalte index
```
PUT _index_template/tak_test
{
  "index_patterns": ["tak_test_*"],
  "template": {
    "mappings": {
      "_source": {
        "enabled": true
      },
      "dynamic": "false",
      "properties": {
        "id": {
          "type": "integer"
        },
        "shopId": {
          "type": "integer"
        },
        "name": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "shopName": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "description": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "optionValues": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "price": {
          "type": "double"
        },
        "salePrice": {
          "type": "double"
        },
        "discountedPercent": {
          "type": "integer"
        },
        "isProhibited": {
          "type": "boolean"
        },
        "isBanned": {
          "type": "boolean"
        },
        "isDisplay": {
          "type": "boolean"
        },
        "isInStock": {
          "type": "boolean"
        },
        "brandType": {
          "type": "integer"
        },
        "hasRLP": {
          "type": "boolean"
        },
        "isGift": {
          "type": "boolean"
        },
        "cvr": {
          "type": "rank_feature"
        },
        "numPageview": {
          "type": "rank_feature"
        },
        "numClicks": {
          "type": "rank_feature"
        },
        "soldQuantity": {
          "type": "integer"
        }
      }
    },
    "settings": {
      "number_of_shards": "1",
      "auto_expand_replicas": "0-all",
      "max_result_window": "5000",
      "analysis": {
        "filter": {
          "thai_stop": {
            "type": "stop",
            "stopwords": [ "ไว้", "ไป", "ได้", "ใน", "โดย", "แล้ว", "แต่", "เลย", "เริ่ม", "เรา", "เมื่อ", "เพราะ", "เป็นการ", "เป็น", "เปิดเผย", "เนื่องจาก", "เดียวกัน", "เดียว", "เช่น", "เฉพาะ", "เข้า", "เขา", "อีก", "อาจ", "อะไร", "อยู่", "อยาก", "หาก", "หลังจาก", "หรือ", "หนึ่ง", "ส่วน", "สุด", "สําหรับ", "ว่า", "ลง", "ร่วม", "ราย", "ระหว่าง", "ยัง", "มี", "มาก", "มา", "พบ", "นี้", "นํา", "นั้น", "นอกจาก", "ทุก", "ที่", "ทั้งนี้", "ทั้ง", "ถ้า", "ถูก", "ถึง", "ต้อง", "ต่างๆ", "ต่าง", "ตั้งแต่", "ด้วย", "ซึ่ง", "จึง", "จะ", "คือ", "ครั้ง", "คง", "ขึ้น", "ขณะ", "ก่อน", "ก็", "กับ", "กว่า", "กล่าว" ]
          }
        },
        "analyzer": {
          "rebuilt_thai": {
            "tokenizer": "thai",
            "char_filter": ["tokenized_char_mapping_filter"],
            "filter": ["lowercase", "asciifolding", "decimal_digit", "thai_stop"]
          }
        },
        "char_filter": {
          "tokenized_char_mapping_filter": {
            "type": "mapping",
            "mappings": [
              "- => _",
              "’ => '"
            ]
          }
        }
      }
    }
  }
}

```

## 2. rename template
```
PUT /tak_test_01
GET tak_test_01
```

## 3. insert data
```
PUT /tak_test_01/_doc/1
{
  "name": "หมา",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/2
{
  "name": "สุนัข",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/3
{
  "name": "shower",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
  
}

PUT /tak_test_01/_doc/4
{
  "name": "อาบน้ำ",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/5
{
  "name": "ยูเซอริน",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/6
{
  "name": "Eucerin",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/7
{
  "name": "หมาชิสุ",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/8
{
  "name": "หมาภูเขา",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/9
{
  "name": "ชิสุ",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/10
{
  "name": "ลาบราดอร์",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

PUT /tak_test_01/_doc/11
{
  "name": "พุดเดิ้ล",
  "isDisplay": true,
  "isProhibited": false,
  "isBanned": false
}

```

## 4. setup synonyms filter (tak_test_01 => tak_test_02) (synonym)
```
PUT _index_template/tak_test
{
  "index_patterns": ["tak_test_*"],
  "template": {
    "mappings": {
      "_source": {
        "enabled": true
      },
      "dynamic": "false",
      "properties": {
        "id": {
          "type": "integer"
        },
        "shopId": {
          "type": "integer"
        },
        "name": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "shopName": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "description": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "optionValues": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "price": {
          "type": "double"
        },
        "salePrice": {
          "type": "double"
        },
        "discountedPercent": {
          "type": "integer"
        },
        "isProhibited": {
          "type": "boolean"
        },
        "isBanned": {
          "type": "boolean"
        },
        "isDisplay": {
          "type": "boolean"
        },
        "isInStock": {
          "type": "boolean"
        },
        "brandType": {
          "type": "integer"
        },
        "hasRLP": {
          "type": "boolean"
        },
        "isGift": {
          "type": "boolean"
        },
        "cvr": {
          "type": "rank_feature"
        },
        "numPageview": {
          "type": "rank_feature"
        },
        "numClicks": {
          "type": "rank_feature"
        },
        "soldQuantity": {
          "type": "integer"
        }
      }
    },
    "settings": {
      "number_of_shards": "1",
      "auto_expand_replicas": "0-all",
      "max_result_window": "5000",
      "analysis": {
        "filter": {
          "thai_stop": {
            "type": "stop",
            "stopwords": [ "ไว้", "ไป", "ได้", "ใน", "โดย", "แล้ว", "แต่", "เลย", "เริ่ม", "เรา", "เมื่อ", "เพราะ", "เป็นการ", "เป็น", "เปิดเผย", "เนื่องจาก", "เดียวกัน", "เดียว", "เช่น", "เฉพาะ", "เข้า", "เขา", "อีก", "อาจ", "อะไร", "อยู่", "อยาก", "หาก", "หลังจาก", "หรือ", "หนึ่ง", "ส่วน", "สุด", "สําหรับ", "ว่า", "ลง", "ร่วม", "ราย", "ระหว่าง", "ยัง", "มี", "มาก", "มา", "พบ", "นี้", "นํา", "นั้น", "นอกจาก", "ทุก", "ที่", "ทั้งนี้", "ทั้ง", "ถ้า", "ถูก", "ถึง", "ต้อง", "ต่างๆ", "ต่าง", "ตั้งแต่", "ด้วย", "ซึ่ง", "จึง", "จะ", "คือ", "ครั้ง", "คง", "ขึ้น", "ขณะ", "ก่อน", "ก็", "กับ", "กว่า", "กล่าว" ]
          },
          "synonym_filter": {
            "type": "synonym",
            "synonyms": [
              "หมา => สุนัข",
              "shower => อาบน้ำ",
              "ยูเซอริน => Eucerin",
              "พุดเดิ้ล,ชิสุ,ลาบราดอร์,คอร์กี้"
            ]
          }
        },
        "analyzer": {
          "rebuilt_thai": {
            "tokenizer": "thai",
            "char_filter": ["tokenized_char_mapping_filter"],
            "filter": ["lowercase", "asciifolding", "decimal_digit", "thai_stop", "synonym_filter"]
          }
        },
        "char_filter": {
          "tokenized_char_mapping_filter": {
            "type": "mapping",
            "mappings": [
              "- => _",
              "’ => '"
            ]
          }
        }
      }
    }
  }
}

# reindex

POST _reindex?wait_for_completion=false&slices=auto
{
  "source": {
    "index": "tak_test_01"
  },
  "dest": {
    "index": "tak_test_02"
  }
}

# check rebuilt_thai

GET /tak_test_02/_analyze
{
  "analyzer": "rebuilt_thai",
  "text": "หมา"
}

```
# 5. check result (Term is an exact query, Match is a fuzzy query)
```
GET tak_test_02/_search
{
  "query": {
    "match": {
      "name": "หมา"
    }
  }
}
```

# 6. apply filter product
```
GET tak_test_02/_search
{
  "_source": ["shopName", "brandType", "name", "shopId"],
  "query": {
    "bool": {
      "must": {
        "multi_match": {
          "query": "หมา",
          "operator": "or",
          "type": "cross_fields",
          "fields": [
            "name",
            "description",
            "optionValues",
            "shopName^3"
          ]
        }
      },
      "should": [
        {
          "multi_match": {
            "query": "หมา",
            "operator": "or",
            "type": "most_fields",
            "fields": [
              "name^4",
              "description^2",
              "optionValues",
              "shopName^10"
            ]
          }
        },
        {
          "constant_score": {
            "filter": {
              "term": {
                "brandType": 3
              }
            },
            "boost": 200
          }
        },
        {
          "constant_score": {
            "filter": {
              "term": {
                "brandType": 2
              }
            },
            "boost": 195
          }
        },
        {
          "rank_feature": {
            "field": "cvr"
          }
        },
        {
          "rank_feature": {
            "field": "numPageview"
          }
        },
        {
          "rank_feature": {
            "field": "numClicks"
          }
        }
      ],
      "filter": [
        {
          "term": {
            "isDisplay": true
          }
        }
      ],
      "must_not": [
        {
          "term": {
            "isProhibited": true
          }
        },
        {
          "term": {
            "isBanned": true
          }
        }
      ]
    }
  },
  "sort": [
    {
      "_score": {
        "order": "desc"
      }
    },
    {
      "id": {
        "order": "desc"
      }
    }
  ],
  "size": 1000
}
```


# 7. setup synonyms filter! (tak_test_02 => tak_test_03) (synonym_graph)
```
PUT _index_template/tak_test
{
  "index_patterns": ["tak_test_*"],
  "template": {
    "mappings": {
      "_source": {
        "enabled": true
      },
      "dynamic": "false",
      "properties": {
        "id": {
          "type": "integer"
        },
        "shopId": {
          "type": "integer"
        },
        "name": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "shopName": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "description": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "optionValues": {
          "type": "text",
          "analyzer": "rebuilt_thai"
        },
        "price": {
          "type": "double"
        },
        "salePrice": {
          "type": "double"
        },
        "discountedPercent": {
          "type": "integer"
        },
        "isProhibited": {
          "type": "boolean"
        },
        "isBanned": {
          "type": "boolean"
        },
        "isDisplay": {
          "type": "boolean"
        },
        "isInStock": {
          "type": "boolean"
        },
        "brandType": {
          "type": "integer"
        },
        "hasRLP": {
          "type": "boolean"
        },
        "isGift": {
          "type": "boolean"
        },
        "cvr": {
          "type": "rank_feature"
        },
        "numPageview": {
          "type": "rank_feature"
        },
        "numClicks": {
          "type": "rank_feature"
        },
        "soldQuantity": {
          "type": "integer"
        }
      }
    },
    "settings": {
      "number_of_shards": "1",
      "auto_expand_replicas": "0-all",
      "max_result_window": "5000",
      "analysis": {
        "filter": {
          "thai_stop": {
            "type": "stop",
            "stopwords": [ "ไว้", "ไป", "ได้", "ใน", "โดย", "แล้ว", "แต่", "เลย", "เริ่ม", "เรา", "เมื่อ", "เพราะ", "เป็นการ", "เป็น", "เปิดเผย", "เนื่องจาก", "เดียวกัน", "เดียว", "เช่น", "เฉพาะ", "เข้า", "เขา", "อีก", "อาจ", "อะไร", "อยู่", "อยาก", "หาก", "หลังจาก", "หรือ", "หนึ่ง", "ส่วน", "สุด", "สําหรับ", "ว่า", "ลง", "ร่วม", "ราย", "ระหว่าง", "ยัง", "มี", "มาก", "มา", "พบ", "นี้", "นํา", "นั้น", "นอกจาก", "ทุก", "ที่", "ทั้งนี้", "ทั้ง", "ถ้า", "ถูก", "ถึง", "ต้อง", "ต่างๆ", "ต่าง", "ตั้งแต่", "ด้วย", "ซึ่ง", "จึง", "จะ", "คือ", "ครั้ง", "คง", "ขึ้น", "ขณะ", "ก่อน", "ก็", "กับ", "กว่า", "กล่าว" ]
          },
          "synonym_filter": {
            "type": "synonym",
            "synonyms": [
              "หมา,สุนัข,ชิสุ,น้อน,น้อง,พุดเดิ้ล,ชิสุ,ลาบราดอร์,คอร์กี้",
              "shower,อาบน้ำ,take shower,แช่น้ำ",
              "ยูเซอริน,Eucerin"
            ]
          }
        },
        "analyzer": {
          "rebuilt_thai": {
            "tokenizer": "thai",
            "char_filter": ["tokenized_char_mapping_filter"],
            "filter": ["lowercase", "asciifolding", "decimal_digit", "thai_stop", "synonym_filter"]
          }
        },
        "char_filter": {
          "tokenized_char_mapping_filter": {
            "type": "mapping",
            "mappings": [
              "- => _",
              "’ => '"
            ]
          }
        }
      }
    }
  }
}

# reindex

POST _reindex?wait_for_completion=false&slices=auto
{
  "source": {
    "index": "tak_test_02"
  },
  "dest": {
    "index": "tak_test_03"
  }
}
```
# 8. query check
```
GET tak_test_03/_search
{
  "query": {
    "match": {
      "name": "หมา"
    }
  }
}
```

# 9. เราจะเอามา implement ยังไงต่อ
 - 1. add templete ไปก่อนถ้าไม่เยอะ 
 
 - 2. ทำ plugin
 
    - 2.1 NLP (Natural Language Processing) install plugin
      - Word2vec: คาดการณ์บริบทของคำ (context)
      - GloVe: ใช้สถิติที่เกิดขึ้นร่วมกันเพื่อสร้างเวกเตอร์คำ
    - ข้อสังเกต
      ถ้าเป็นภาษาไทยมันจะไม่เหมือนภาษาอื่น
      ยกตัวอย่าง: 
        แมว,แมวน้ำ  => vector(1)
        ผี,ผีแดง => vector(2) , manchester united
       เป็ดกาก,หงส์แดง , liverpool

    - 2.2 dynamic synonyms
      - https://github.com/new-black/flexible-synonyms
      - https://github.com/bells/elasticsearch-analysis-dynamic-synonym




















