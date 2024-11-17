import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;

public class goldenModel {

    //8 bits por amostra
    //64 amostras
    //4 simultâneas

    public static void main(String[] args) throws IOException {

        Random random = new Random();

        File outputfile = new File("estimulos.dat");

        FileWriter fileWriter = new FileWriter(outputfile);

        if (!outputfile.exists()) {
            outputfile.createNewFile();
        } else {
            fileWriter.flush();
        }

        int sadValue = 0;
        int[] intInputsA = new int[4];
        int[] intInputsB = new int[4];
        int[] abs = new int[4];
        for (int p = 0; p<50; p++) {

            for(int i = 0; i<16 ;i++) {
                StringBuilder line = new StringBuilder();
                for (int j = 0; j < 4; j++) {
                    intInputsA[j] = random.nextInt(0, 255);
                    line.append(fillZeroRight(Integer.toBinaryString(intInputsA[j]), 8));
                }
                line.append(" ");
                for (int s = 0; s < 4; s++) {
                    intInputsB[s] = random.nextInt(0, 255);
                    line.append(fillZeroRight(Integer.toBinaryString(intInputsB[s]), 8));
                    abs[s] = Math.abs(intInputsA[s] - intInputsB[s]);
                    sadValue = sadValue + abs[s];
                }

                fileWriter.append(line);
                fileWriter.append("\n");
            }
            fileWriter.append(fillZeroRight(Integer.toBinaryString(sadValue),14));
            fileWriter.append("\n");
            sadValue = 0;
        }
        fileWriter.close();


    }

    private static String fillZeroRight(String source,int finalLength){
        String r = source;
        for(int i = 0; i<finalLength-source.length(); i++){
            r = "0" + r;
        }
        return r;
    }
}
