package com.digio.kyc_workflow

import org.json.JSONArray
import org.json.JSONObject


object JsonUtils {
    fun jsonToMap(json: JSONObject): Map<String?, Any?> {
        var retMap: Map<String?, Any?> = HashMap()
        if (json !== JSONObject.NULL) {
            retMap = toMap(json)
        }
        return retMap
    }

    fun toMap(jsonObject: JSONObject): Map<String?, Any?> {
        val map: MutableMap<String?, Any?> = HashMap()
        val keysItr: Iterator<Any?> = jsonObject.keys().iterator()
        while (keysItr.hasNext()) {
            val key = keysItr.next().toString()
            var value: Any = jsonObject.get(key)
            if (value is JSONArray) {
                value = toList(value)
            } else if (value is JSONObject) {
                value = toMap(value)
            }
            map[key] = value
        }
        return map
    }

    fun toList(array: JSONArray): List<Any> {
        val list: MutableList<Any> = ArrayList()
        for (i in 0 until array.length()) {
            var value: Any = array.get(i)
            if (value is JSONArray) {
                value = toList(value as JSONArray)
            } else if (value is JSONObject) {
                value = toMap(value as JSONObject)
            }
            list.add(value)
        }
        return list
    }
}