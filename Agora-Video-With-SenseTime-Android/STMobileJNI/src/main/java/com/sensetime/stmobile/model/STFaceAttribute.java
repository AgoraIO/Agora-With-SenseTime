package com.sensetime.stmobile.model;


/**
 * 定义人脸属性信息，比如年龄，性别，颜值
 */

public class STFaceAttribute {
    public int attribute_count;
    public Attribute[] arrayAttribute;

    public static class Attribute {
        String category; // 属性描述, 如"age", "gender", "attractive"
        String label; //属性标签描述， 如"male", "female"，"35"等
        float score; //该属性标签的置信度

        public float getScore() {
            return score;
        }

        public String getCategory() {
            return category;
        }

        public String getLabel() {
            return label;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public void setScore(float score) {
            this.score = score;
        }
    }

    public static String getFaceAttributeString(STFaceAttribute arrayFaceAttribute){
        String attribute = null;
        String attractive = null;
        String gender = "男";
        String age = "";

        for(int i = 0; i < arrayFaceAttribute.arrayAttribute.length; i++){
            if(arrayFaceAttribute.arrayAttribute[i].category.equals("attractive")){
                attractive = arrayFaceAttribute.arrayAttribute[i].label;
            }

            if(arrayFaceAttribute.arrayAttribute[i].category.equals("gender")){
                gender = arrayFaceAttribute.arrayAttribute[i].label;
                if(gender.equals("male")){
                    gender = "男";
                }else{
                    gender = "女";
                }
            }

            if(arrayFaceAttribute.arrayAttribute[i].category.equals("age")){
                age = arrayFaceAttribute.arrayAttribute[i].label;
            }
        }

        attribute = "颜值:" + attractive + "  " + "性别:" + gender + "  " + "年龄:"+ age;
        return attribute;
    }

    public Attribute[] getArrayAttribute() {
        return arrayAttribute;
    }

    public int getAttributeCount() {
        return attribute_count;
    }

    public void setArrayAttribute(Attribute[] arrayAttribute) {
        this.arrayAttribute = arrayAttribute;
    }

    public void setAttributeCount(int attribute_count) {
        this.attribute_count = attribute_count;
    }

    public static boolean isMale(STFaceAttribute arrayFaceAttribute){
        String gender = "";
        boolean isMale = false;
        for(int i = 0; i < arrayFaceAttribute.arrayAttribute.length; i++) {
            if (arrayFaceAttribute.arrayAttribute[i].category.equals("gender")) {
                gender = arrayFaceAttribute.arrayAttribute[i].label;
                if (gender.equals("male")) {
                    isMale = true;
                } else {
                    isMale = false;
                }
            }
        }
        return isMale;
    }
}
