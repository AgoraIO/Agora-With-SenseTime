package com.sensetime.effects.utils;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;

import com.sensetime.effects.R;
import com.sensetime.effects.view.FilterItem;
import com.sensetime.effects.view.MakeupItem;
import com.sensetime.effects.view.ObjectItem;
import com.sensetime.effects.view.StickerItem;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

public class FileUtils {
    private static final int DEFAULT_BUFFER_SIZE = 256;
    private static final byte[] DEFAULT_READ_BUFFER = new byte[256];

    public static final String MODEL_NAME_ACTION = "M_SenseME_Face_Video_5.3.4.model";
    public static final String MODEL_NAME_FACE_ATTRIBUTE = "M_SenseME_Attribute_1.0.1.model";
    public static final String MODEL_NAME_EYEBALL_CENTER = "M_Eyeball_Center.model";
    public static final String MODEL_NAME_EYEBALL_CONTOUR = "M_SenseME_Iris_2.0.0.model";
    public static final String MODEL_NAME_FACE_EXTRA = "M_SenseME_Face_Extra_5.23.0.model";
    public static final String MODEL_NAME_HAND = "M_SenseME_Hand_5.4.0.model";
    public static final String MODEL_NAME_SEGMENT = "M_SenseME_Segment_4.10.8.model";
    public static final String MODEL_NAME_BODY_FOURTEEN = "M_SenseME_Body_Fourteen_1.2.0.model";
    public static final String MODEL_NAME_AVATAR_CORE = "M_SenseME_Avatar_Core_2.0.0.model";
    public static final String MODEL_NAME_CATFACE_CORE = "M_SenseME_CatFace_2.0.0.model";
    public static final String MODEL_NAME_AVATAR_HELP = "M_SenseME_Avatar_Help_2.0.0.model";
    public static final String MODEL_NAME_TONGUE = "M_Align_DeepFace_Tongue_1.0.0.model";

    public static String getActionModelName() {
        return MODEL_NAME_ACTION;
    }

    public static String getEyeBallCenterModelName() {
        return MODEL_NAME_EYEBALL_CENTER;
    }

    public static String getEyeBallContourModelName() {
        return MODEL_NAME_EYEBALL_CONTOUR;
    }

    public static String getFaceExtraModelName() {
        return MODEL_NAME_FACE_EXTRA;
    }

    public static ArrayList<String> copyStickerFiles(Context context) {
        String files[] = null;
        ArrayList<String> zipfiles = new ArrayList<String>();

        try {
            files = context.getAssets().list("");
        } catch (IOException e) {
            e.printStackTrace();
        }

        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath();
        }
        for (int i = 0; i < files.length; i++) {
            String str = files[i];
            if (str.indexOf(".zip") != -1) {
                copyFileIfNeed(context, str);
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                String path = subFile[i].getPath();
                // 判断是否为zip结尾
                if (filename.trim().toLowerCase().endsWith(".zip")) {
                    zipfiles.add(filename);
                }
            }
        }

        return zipfiles;
    }

    public static boolean copyFileIfNeed(Context context, String fileName) {
        String path = getFilePath(context, fileName);
        if (path != null) {
            File file = new File(path);
            if (!file.exists()) {
                //如果模型文件不存在
                try {
                    if (file.exists())
                        file.delete();

                    file.createNewFile();
                    InputStream in = context.getApplicationContext().getAssets().open(fileName);
                    if (in == null) {
                        LogUtils.e("copyMode", "the src is not existed");
                        return false;
                    }
                    OutputStream out = new FileOutputStream(file);
                    byte[] buffer = new byte[4096];
                    int n;
                    while ((n = in.read(buffer)) > 0) {
                        out.write(buffer, 0, n);
                    }
                    in.close();
                    out.close();
                } catch (IOException e) {
                    file.delete();
                    return false;
                }
            }
        }
        return true;
    }

    public static boolean copyFileIfNeed(Context context, String fileName, String className) {
        String path = getFilePath(context, className + File.separator + fileName);
        if (path != null) {
            File file = new File(path);
            if (!file.exists()) {
                //如果模型文件不存在
                try {
                    if (file.exists())
                        file.delete();

                    file.createNewFile();

                    InputStream in = context.getAssets().open(className + File.separator + fileName);
                    if (in == null) {
                        LogUtils.e("copyMode", "the src is not existed");
                        return false;
                    }
                    OutputStream out = new FileOutputStream(file);
                    byte[] buffer = new byte[4096];
                    int n;
                    while ((n = in.read(buffer)) > 0) {
                        out.write(buffer, 0, n);
                    }
                    in.close();
                    out.close();
                } catch (IOException e) {
                    file.delete();
                    return false;
                }
            }
        }
        return true;
    }

    public static String getFilePath(Context context, String fileName) {
        String path = null;
        File dataDir = context.getApplicationContext().getExternalFilesDir(null);
        if (dataDir != null) {
            path = dataDir.getAbsolutePath() + File.separator + fileName;
        }
        return path;
    }

    public static File getOutputMediaFile() {
        File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DCIM), "Camera");
        // This location works best if you want the created images to be shared
        // between applications and persist after your app has been uninstalled.

        // Create the storage directory if it does not exist
        if (!mediaStorageDir.exists()) {
            if (!mediaStorageDir.mkdirs()) {
                LogUtils.e("FileUtil", "failed to create directory");
                return null;
            }
        }

        // Create a media file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.CHINESE).format(new Date());
        File mediaFile = new File(mediaStorageDir.getPath() + File.separator +
                "IMG_" + timeStamp + ".jpg");

        return mediaFile;
    }

    public static void copyModelFiles(Context context) {
        //action模型会从asset直接读取
        //copyFileIfNeed(context, MODEL_NAME_ACTION);
        copyFileIfNeed(context, MODEL_NAME_FACE_ATTRIBUTE);
        copyFileIfNeed(context, MODEL_NAME_AVATAR_CORE);
        copyFileIfNeed(context, MODEL_NAME_CATFACE_CORE);
    }


    public static String getTrackModelPath(Context context) {
        return getFilePath(context, MODEL_NAME_ACTION);

    }

    public static String getFaceAttributeModelPath(Context context) {
        return getFilePath(context, MODEL_NAME_FACE_ATTRIBUTE);
    }

    public static String getAvatarCoreModelPath(Context context) {
        return getFilePath(context, MODEL_NAME_AVATAR_CORE);
    }

//    public static List<ObjectItem> getObjectList() {
//        List<ObjectItem> objectList = new ArrayList<>();
//
//        objectList.add(new ObjectItem("object_hi", R.drawable.object_hi));
//        objectList.add(new ObjectItem("object_happy", R.drawable.object_happy));
//        objectList.add(new ObjectItem("object_star", R.drawable.object_star));
//
//        objectList.add(new ObjectItem("object_sticker", R.drawable.object_sticker));
//        objectList.add(new ObjectItem("object_love", R.drawable.object_love));
//        objectList.add(new ObjectItem("object_sun", R.drawable.object_sun));
//
//        return objectList;
//    }

    public static void copyStickerFiles(Context context, String index) {
        copyStickerZipFiles(context, index);
        copyStickerIconFiles(context, index);
    }

    public static void copyFilterFiles(Context context, String index) {
        copyFilterModelFiles(context, index);
        copyFilterIconFiles(context, index);
    }

//    public static ArrayList<StickerItem> getStickerFiles(Context context, String index) {
//        ArrayList<StickerItem> stickerFiles = new ArrayList<StickerItem>();
//        //Bitmap iconClose = BitmapFactory.decodeResource(context.getResources(), R.drawable.close_sticker);
//        Bitmap iconNone = BitmapFactory.decodeResource(context.getResources(), R.drawable.none);
//
//        List<String> stickerModels = getStickerZipFilesFromSd(context, index);
//        Map<String, Bitmap> stickerIcons = getStickerIconFilesFromSd(context, index);
//        List<String> stickerNames = getStickerNames(context, index);
//
//        for (int i = 0; i < stickerModels.size(); i++) {
//            if (stickerIcons.get(stickerNames.get(i)) != null)
//                stickerFiles.add(new StickerItem(stickerNames.get(i), stickerIcons.get(stickerNames.get(i)), stickerModels.get(i)));
//            else {
//                stickerFiles.add(new StickerItem(stickerNames.get(i), iconNone, stickerModels.get(i)));
//            }
//        }
//
//        return stickerFiles;
//    }

    public static List<String> copyStickerZipFiles(Context context, String className) {
        String files[] = null;
        ArrayList<String> modelFiles = new ArrayList<String>();

        try {
            files = context.getAssets().list(className);
        } catch (IOException e) {
            e.printStackTrace();
        }

        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + className;

            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }
        for (int i = 0; i < files.length; i++) {
            String str = files[i];
            if (str.indexOf(".zip") != -1 || str.indexOf(".model") != -1) {
                copyFileIfNeed(context, str, className);
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return modelFiles;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                String path = subFile[i].getPath();
                // 判断是否为model结尾
                if (filename.trim().toLowerCase().endsWith(".zip") || filename.trim().toLowerCase().endsWith(".model")) {
                    modelFiles.add(filename);
                }
            }
        }

        return modelFiles;
    }

    public static List<String> getStickerZipFilesFromSd(Context context, String className) {
        ArrayList<String> modelFiles = new ArrayList<String>();

        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + className;

            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return modelFiles;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                String path = subFile[i].getPath();
                // 判断是否为model结尾
                if (filename.trim().toLowerCase().endsWith(".zip") || filename.trim().toLowerCase().endsWith(".model")) {
                    modelFiles.add(filename);
                }
            }
        }

        return modelFiles;
    }

    public static Map<String, Bitmap> copyStickerIconFiles(Context context, String className) {
        String files[] = null;
        TreeMap<String, Bitmap> iconFiles = new TreeMap<String, Bitmap>();

        try {
            files = context.getAssets().list(className);
        } catch (IOException e) {
            e.printStackTrace();
        }

        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + className;

            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }
        for (int i = 0; i < files.length; i++) {
            String str = files[i];
            if (str.indexOf(".png") != -1) {
                copyFileIfNeed(context, str, className);
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return iconFiles;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                String path = subFile[i].getPath();
                // 判断是否为png结尾
                if (filename.trim().toLowerCase().endsWith(".png") && filename.indexOf("mode_") == -1) {
                    String name = subFile[i].getName();
                    iconFiles.put(getFileNameNoEx(name), BitmapFactory.decodeFile(filename));
                }
            }
        }

        return iconFiles;
    }

    public static Map<String, Bitmap> getStickerIconFilesFromSd(Context context, String className) {
        TreeMap<String, Bitmap> iconFiles = new TreeMap<String, Bitmap>();

        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + className;

            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return iconFiles;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                String path = subFile[i].getPath();
                // 判断是否为png结尾
                if (filename.trim().toLowerCase().endsWith(".png") && filename.indexOf("mode_") == -1) {
                    String name = subFile[i].getName();
                    iconFiles.put(getFileNameNoEx(name), BitmapFactory.decodeFile(filename));
                }
            }
        }

        return iconFiles;
    }

    public static List<String> getStickerNames(Context context, String className) {
        ArrayList<String> modelNames = new ArrayList<String>();
        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + className;
            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return modelNames;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                // 判断是否为model结尾
                if (filename.trim().toLowerCase().endsWith(".zip") || filename.trim().toLowerCase().endsWith(".model")) {
                    String name = subFile[i].getName();
                    modelNames.add(getFileNameNoEx(name));
                }
            }
        }

        return modelNames;
    }

//    public static ArrayList<FilterItem> getFilterFiles(Context context, String index) {
//        ArrayList<FilterItem> filterFiles = new ArrayList<FilterItem>();
//        Bitmap iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.mode_original);
//
//        if (index.equals("filter_portrait")) {
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.filter_portrait_nature);
//        } else if (index.equals("filter_scenery")) {
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.filter_scenery_nature);
//        } else if (index.equals("filter_still_life")) {
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.filter_still_life_nature);
//        } else if (index.equals("filter_food")) {
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.filter_food_nature);
//        }
//        filterFiles.add(new FilterItem("original", iconNature, null));
//        //filterFiles.add(new FilterItem("null", iconNature, null));
//
//        List<String> filterModels = copyFilterModelFiles(context, index);
//        Map<String, Bitmap> filterIcons = copyFilterIconFiles(context, index);
//        List<String> filterNames = getFilterNames(context, index);
//
//        if (filterModels == null || filterModels.size() == 0) {
//            return filterFiles;
//        }
//
//        for (int i = 0; i < filterModels.size(); i++) {
//            if (filterIcons.get(filterNames.get(i)) != null)
//                filterFiles.add(new FilterItem(filterNames.get(i), filterIcons.get(filterNames.get(i)), filterModels.get(i)));
//            else {
//                filterFiles.add(new FilterItem(filterNames.get(i), iconNature, filterModels.get(i)));
//            }
//        }
//
//        return filterFiles;
//    }

    public static List<String> copyFilterModelFiles(Context context, String index) {
        String files[] = null;
        ArrayList<String> modelFiles = new ArrayList<String>();

        try {
            files = context.getAssets().list(index);
        } catch (IOException e) {
            e.printStackTrace();
        }

        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + index;
            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }
        for (int i = 0; i < files.length; i++) {
            String str = files[i];
            if (str.indexOf(".model") != -1) {
                copyFileIfNeed(context, str, index);
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return modelFiles;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                String path = subFile[i].getPath();
                // 判断是否为model结尾
                if (filename.trim().toLowerCase().endsWith(".model") && filename.indexOf("filter") != -1) {
                    modelFiles.add(filename);
                }
            }
        }

        return modelFiles;
    }

    public static Map<String, Bitmap> copyFilterIconFiles(Context context, String index) {
        String files[] = null;
        TreeMap<String, Bitmap> iconFiles = new TreeMap<String, Bitmap>();

        try {
            files = context.getAssets().list(index);
        } catch (IOException e) {
            e.printStackTrace();
        }

        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + index;

            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }
        for (int i = 0; i < files.length; i++) {
            String str = files[i];
            if (str.indexOf(".png") != -1) {
                copyFileIfNeed(context, str, index);
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return iconFiles;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                String path = subFile[i].getPath();
                // 判断是否为png结尾
                if (filename.trim().toLowerCase().endsWith(".png") && filename.indexOf("filter") != -1) {
                    String name = subFile[i].getName().substring(13);
                    iconFiles.put(getFileNameNoEx(name), BitmapFactory.decodeFile(filename));
                }
            }
        }

        return iconFiles;
    }

    public static List<String> getFilterNames(Context context, String index) {
        ArrayList<String> modelNames = new ArrayList<String>();
        String folderpath = null;
        File dataDir = context.getExternalFilesDir(null);
        if (dataDir != null) {
            folderpath = dataDir.getAbsolutePath() + File.separator + index;
            File folder = new File(folderpath);

            if (!folder.exists()) {
                folder.mkdir();
            }
        }

        File file = new File(folderpath);
        File[] subFile = file.listFiles();

        if (subFile == null || subFile.length == 0) {
            return modelNames;
        }

        for (int i = 0; i < subFile.length; i++) {
            // 判断是否为文件夹
            if (!subFile[i].isDirectory()) {
                String filename = subFile[i].getAbsolutePath();
                // 判断是否为model结尾
                if (filename.trim().toLowerCase().endsWith(".model") && filename.indexOf("filter") != -1) {
                    String name = subFile[i].getName().substring(13);
                    modelNames.add(getFileNameNoEx(name));
                }
            }
        }

        return modelNames;
    }

    public static String getFileNameNoEx(String filename) {
        if ((filename != null) && (filename.length() > 0)) {
            int dot = filename.lastIndexOf('.');
            if ((dot > -1) && (dot < (filename.length()))) {
                return filename.substring(0, dot);
            }
        }
        return filename;
    }

//    public static void writeMaterialsToJsonFile(List<SenseArMaterial> materials, String groupId, String rootPath) {
//        if (materials != null && materials.size() > 0) {
//            JSONObject jsonObject = new JSONObject();
//            JSONArray materialsJson = new JSONArray();
//            try {
//                for (SenseArMaterial material : materials) {
//                    JSONObject jsonMaterial = new JSONObject();
//                    jsonMaterial.put("type", material.type);
//                    jsonMaterial.put("id", material.id);
//                    jsonMaterial.put("materialFileId", material.materialFileId);
//                    jsonMaterial.put("materialInstructions", material.materialInstructions);
//                    jsonMaterial.put("extend_info", material.extend_info);
//                    jsonMaterial.put("extend_info2", material.extend_info2);
//                    jsonMaterial.put("thumbnail", material.thumbnail);
//                    jsonMaterial.put("name", material.name);
//                    jsonMaterial.put("cachedPath", material.cachedPath);
//                    materialsJson.put(jsonMaterial);
//                }
//                jsonObject.put("materials", materialsJson);
//                String jsonStr = jsonObject.toString();
//                File file = new File(rootPath + "/" + groupId);
//                file.createNewFile();
//                FileOutputStream fileOutputStream = new FileOutputStream(file);
//                fileOutputStream.write(jsonStr.getBytes());
//                fileOutputStream.close();
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//    }

//    public static List<SenseArMaterial> getMaterialsFromJsonFile(String groupId, String rootPath) {
//        List<SenseArMaterial> result = new ArrayList<>();
//        File file = new File(rootPath + "/" + groupId);
//        if (file.exists()) {
//            try {
//                FileInputStream fileInputStream = new FileInputStream(file);
//                InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream);
//                BufferedReader br = new BufferedReader(inputStreamReader);
//                String line;
//                StringBuilder builder = new StringBuilder();
//                while ((line = br.readLine()) != null) {
//                    builder.append(line);
//                }
//                br.close();
//                inputStreamReader.close();
//                fileInputStream.close();
//
//                JSONObject jsonObject = new JSONObject(builder.toString());
//                JSONArray array = jsonObject.optJSONArray("materials");
//                if (array != null && array.length() > 0) {
//                    for (int i = 0; i < array.length(); i++) {
//                        SenseArMaterial senseArMaterial = new SenseArMaterial();
//                        JSONObject jsonMaterial = array.getJSONObject(i);
//                        senseArMaterial.type = jsonMaterial.optInt("type");
//                        senseArMaterial.id = jsonMaterial.optString("id");
//                        senseArMaterial.materialFileId = jsonMaterial.optString("materialFileId");
//                        senseArMaterial.materialInstructions = jsonMaterial.optString("materialInstructions");
//                        senseArMaterial.extend_info = jsonMaterial.optString("extend_info");
//                        senseArMaterial.extend_info2 = jsonMaterial.optString("extend_info2");
//                        senseArMaterial.thumbnail = jsonMaterial.optString("thumbnail");
//                        senseArMaterial.name = jsonMaterial.optString("name");
//                        senseArMaterial.cachedPath = jsonMaterial.optString("cachedPath");
//                        result.add(senseArMaterial);
//                    }
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//        return result;
//    }

//    public static ArrayList<MakeupItem> getMakeupFilesFromAssets(Context context, String index){
//        ArrayList<MakeupItem> makeupFiles = new ArrayList<MakeupItem>();
//        Bitmap iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//
//        if(index.equals("makeup_lip")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_highlight")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_blush")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_brow")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_eye")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }
//        makeupFiles.add(new MakeupItem("original", iconNature, null));
//
//        List<String> makeupZips = getMakeupFilePathFromAssets(context, index);
//        List<String> makeupNames = getMakeupNamesFromAssets(context, index);
//
//        for(int i = 0;i< makeupZips.size(); i++){
//            if(makeupNames.get(i) != null) {
//                makeupFiles.add(new MakeupItem(makeupNames.get(i), getImageFromAssetsFile(context, index + File.separator+ makeupNames.get(i)+".png"), makeupZips.get(i)));
//            }
//        }
//
//        return  makeupFiles;
//    }

    public static List<String> getMakeupFilePathFromAssets(Context context, String className){
        String files[] = null;
        ArrayList<String> modelFiles = new ArrayList<String>();

        try {
            files = context.getAssets().list(className);
        } catch (IOException e) {
            e.printStackTrace();
        }

        for (int i = 0; i < files.length; i++) {
            String str = files[i];
            if(str.indexOf(".zip") != -1){
                modelFiles.add(className + File.separator + files[i]);
            }
        }

        return modelFiles;
    }

    public static List<String> getMakeupNamesFromAssets(Context context, String className){
        String files[] = null;
        ArrayList<String> modelFiles = new ArrayList<String>();

        try {
            files = context.getAssets().list(className);
        } catch (IOException e) {
            e.printStackTrace();
        }

        for (int i = 0; i < files.length; i++) {
            String str = files[i];
            if(str.indexOf(".zip") != -1){
                modelFiles.add(files[i].substring(0,files[i].length()-4));
            }
        }

        return modelFiles;
    }

//    private static Bitmap getImageFromAssetsFile(Context context, String fileName)
//    {
//        Bitmap image = null;
//        AssetManager am = context.getResources().getAssets();
//        try {
//            InputStream is = am.open(fileName);
//            image = BitmapFactory.decodeStream(is);
//            is.close();
//        }
//        catch (IOException e) {
//            e.printStackTrace();
//
//            image = BitmapFactory.decodeResource(context.getResources(), R.drawable.none);
//        }
//
//        return image;
//    }

//    public static ArrayList<MakeupItem> getMakeupFiles(Context context, String index){
//        ArrayList<MakeupItem> makeupFiles = new ArrayList<MakeupItem>();
//        Bitmap iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//
//        if(index.equals("makeup_lip")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_highlight")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_blush")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_brow")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }else if(index.equals("makeup_eye")){
//            iconNature = BitmapFactory.decodeResource(context.getResources(), R.drawable.makeup_null);
//        }
//        makeupFiles.add(new MakeupItem("original", iconNature, null));
//        //filterFiles.add(new FilterItem("null", iconNature, null));
//
//        List<String> makeupZips = getStickerZipFilesFromSd(context, index);
//        Map<String, Bitmap> makeupIcons = getStickerIconFilesFromSd(context, index);
//        List<String> makeupNames = getStickerNames(context, index);
//
//        if(makeupZips == null || makeupZips.size() == 0){
//            return makeupFiles;
//        }
//
//        if(makeupZips != null || makeupZips.size() > 1){
//            Collections.sort(makeupZips);
//            Collections.sort(makeupNames);
//        }
//
//        for(int i = 0;i< makeupZips.size(); i++){
//            if(makeupIcons.get(makeupNames.get(i)) != null)
//                makeupFiles.add(new MakeupItem(makeupNames.get(i), makeupIcons.get(makeupNames.get(i)), makeupZips.get(i)));
//            else{
//                makeupFiles.add(new MakeupItem(makeupNames.get(i), iconNature, makeupZips.get(i)));
//            }
//        }
//
//        return  makeupFiles;
//    }

    /**
     * Check if the data directory has already have the file
     * of the relative path. If not, copy file from asset folders.
     * @param context context
     * @param path file path relative to root path. The root path may be
     *             the asset root path, or Data dir path
     * @return absolute path of the file
     */
    public static String copyToDataFromAssetIfNotExist(Context context, String path) {
        // Copy to the root of the files directory
        File fileDir = context.getExternalFilesDir(null);
        File targetFile = new File(fileDir, path);

        if (targetFile.exists()) {
            return targetFile.getAbsolutePath();
        }

        try {
            if (!targetFile.getParentFile().exists() &&
                    !targetFile.getParentFile().mkdirs()) {
                return null;
            }

            if (!targetFile.createNewFile()) {
                return null;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        AssetManager am = context.getAssets();
        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;
        try {
            bis = new BufferedInputStream(am.open(path));
            bos = new BufferedOutputStream(new FileOutputStream(targetFile));

            int read;
            while ((read = bis.read(DEFAULT_READ_BUFFER,
                    0, DEFAULT_BUFFER_SIZE)) != -1) {
                bos.write(DEFAULT_READ_BUFFER, 0, read);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (bos != null) {
                try {
                    bos.flush();
                    bos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return targetFile.getAbsolutePath();
    }
}
