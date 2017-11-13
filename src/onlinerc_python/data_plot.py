import glob
import json
import os
import scipy
import scipy.io
import matplotlib.pyplot as plt
import numpy as np
import operator
from matplotlib import cm
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import LinearLocator, FormatStrFormatter


class DataPlot:

    def __init__(self):
        self.init_plotting()
        pass

    def init_plotting(self):
        plt.rcParams['figure.figsize'] = (6.5, 5)
        plt.rcParams['font.size'] = 15
        #plt.rcParams['font.family'] = 'Times New Roman'
        plt.rcParams['axes.labelsize'] = plt.rcParams['font.size']
        plt.rcParams['axes.titlesize'] = 20
        plt.rcParams['legend.fontsize'] = 13
        plt.rcParams['xtick.labelsize'] = plt.rcParams['font.size']
        plt.rcParams['ytick.labelsize'] = plt.rcParams['font.size']
        plt.rcParams['savefig.dpi'] = plt.rcParams['savefig.dpi']
        plt.rcParams['xtick.major.size'] = 3
        plt.rcParams['xtick.minor.size'] = 3
        plt.rcParams['xtick.major.width'] = 1
        plt.rcParams['xtick.minor.width'] = 1
        plt.rcParams['ytick.major.size'] = 3
        plt.rcParams['ytick.minor.size'] = 3
        plt.rcParams['ytick.major.width'] = 1
        plt.rcParams['ytick.minor.width'] = 1
        #plt.rcParams['legend.frameon'] = True
        #plt.rcParams['legend.loc'] = 'center left'
        #plt.rcParams['legend.loc'] = 'center left'
        plt.rcParams['axes.linewidth'] = 2

        #plt.gca().spines['right'].set_color('none')
        #plt.gca().spines['top'].set_color('none')
        #plt.gca().xaxis.set_ticks_position('bottom')
        #plt.gca().yaxis.set_ticks_position('left')

    def draw_beta_recovery(self, result_dir, b, k, p, bNoise):

        if bNoise:
            noise_str = ""
        else:
            noise_str = "_nn"

        recovery_file = result_dir + 'beta_' + str(b) + 'B_' + str(k) + 'K_' + 'p' + str(p) + noise_str + '.mat'
        mat_contents = scipy.io.loadmat(recovery_file)
        Y_OLS = mat_contents["OLS_result"][0].tolist()
        Y_RLHH = mat_contents["RLHH_result"][0].tolist()
        Y_OPAA = mat_contents["OPAA_result"][0].tolist()
        Y_ORL= mat_contents["ORL_result"][0].tolist()
        Y_ORL0 = mat_contents["ORL0_result"][0].tolist()
        Y_DRLR = mat_contents["BatchRC_result"][0].tolist()
        Y_ORLR = mat_contents["OnlineRC_result"][0].tolist()

        #x = [i*0.05 for i in range(2, 25)]
        x = [i*0.05 for i in range(1, len(Y_ORLR) + 1)]
        # plt.xticks(x, xticks)
        # begin subplots region
        # plt.subplot(121)
        plt.gca().margins(0.1, 0.1)
        ms = 7
        plt.plot(x, Y_OLS, linestyle='--', marker='d', markersize=ms, linewidth=3, color='#5461AA', label='OLS-AVG')
        plt.plot(x, Y_RLHH, linestyle='--', marker='o', markersize=ms, linewidth=3, color='green', label='RLHH-AVG')
        plt.plot(x, Y_OPAA, linestyle='-.', marker='v', markersize=ms, linewidth=3, color='blue', label='OPAA')
        plt.plot(x, Y_ORL, linestyle='-.', marker='<', markersize=ms, linewidth=3, color='#F27441', label='ORL-H')
        plt.plot(x, Y_ORL0, linestyle='--', marker='s', markersize=ms, linewidth=3, color='#BD90D4', label='ORL*')
        plt.plot(x, Y_DRLR, linestyle=':', marker='^', markersize=ms, linewidth=3, color='cyan', label='DRLR')
        plt.plot(x, Y_ORLR, linestyle='-', marker='o', markersize=ms, linewidth=3, color='red', label='ORLR')

        plt.xlabel(u'Corruption Ratio')
        plt.ylabel(r'$\|\beta - \beta^*\|_2$')

        # plt.xlim(1,len(Y_residual)+1)
        #plt.title(u'Subspace-Accuracy/NMI')

        # plt.yaxis.grid(color='gray', linestyle='dashed')

        #plt.gca().legend(bbox_to_anchor=(0.99, 0.99))
        #plt.gca().legend(bbox_to_anchor=(0.349, 1.005))
        #plt.gca().legend(loc = 'upper center', ncol=3)
        leg = plt.gca().legend(loc='upper left')
        leg.get_frame().set_alpha(0.7)
        #plt.yscale('log')

        '''
        if b == 10 and k == 5 and p == 100 and bNoise == 1:
            plt.ylim(0.0, 0.5)
        elif b == 10 and k == 10 and p == 100 and bNoise == 1:
            plt.ylim(0.0, 0.4)
        elif b == 10 and k == 10 and p == 400 and bNoise == 1:
            plt.ylim(0.0, 0.5)  # used for 4K
        elif b == 10 and k == 1 and p == 200 and bNoise == 1:
            plt.ylim(0.15, 0.45)
        elif b == 10 and k == 2 and p == 200 and bNoise == 1:
            plt.ylim(0.1, 0.45)
        elif b == 10 and k == 2 and p == 200 and bNoise == 0:
            plt.ylim(-0.02, 0.45)
        elif b == 10 and k == 4 and p == 400 and bNoise == 0:
            plt.ylim(-0.05, 1.95)
        '''
        plt.show()

        #pp = PdfPages("D:/Dropbox/PHD/publications/IJCAI2017_RLHH/images/beta_1.pdf")
        #plt.savefig(pp, format='pdf')
        #plt.close()

    def draw_runtime_cr(self, result_dir, k, p, b, bNoise):

        if bNoise:
            noise_str = ""
        else:
            noise_str = "_nn"

        runtime_file = result_dir + 'runtime_' + str(b) + 'B_' + str(k) + 'K_' + 'p' + str(p) + noise_str + '.mat'
        mat_contents = scipy.io.loadmat(runtime_file)
        Y_OLS = mat_contents["OLS_result"][0].tolist()
        Y_RLHH = mat_contents["RLHH_result"][0].tolist()
        Y_OPAA = mat_contents["OPAA_result"][0].tolist()
        Y_ORL = mat_contents["ORL_result"][0].tolist()
        Y_ORL0 = mat_contents["ORL0_result"][0].tolist()
        Y_DRLR = mat_contents["BatchRC_result"][0].tolist()
        Y_ORLR = mat_contents["OnlineRC_result"][0].tolist()

        #x = [i*0.05 for i in range(2, 25)]
        x = [i*0.05 for i in range(1, len(Y_ORLR) + 1)]
        # plt.xticks(x, xticks)
        # begin subplots region
        # plt.subplot(121)
        plt.gca().margins(0.1, 0.1)
        ms = 7
        plt.plot(x, Y_OLS, linestyle='--', marker='d', markersize=ms, linewidth=3, color='#5461AA', label='OLS')
        plt.plot(x, Y_RLHH, linestyle='--', marker='o', markersize=ms, linewidth=3, color='green', label='RLHH')
        plt.plot(x, Y_OPAA, linestyle='-.', marker='v', markersize=ms, linewidth=3, color='blue', label='OPAA')
        plt.plot(x, Y_ORL, linestyle='-.', marker='<', markersize=ms, linewidth=3, color='#F27441', label='ORL-H')
        plt.plot(x, Y_ORL0, linestyle='--', marker='s', markersize=ms, linewidth=3, color='#BD90D4', label='ORL*')
        plt.plot(x, Y_DRLR, linestyle=':', marker='^', markersize=ms, linewidth=3, color='cyan', label='DRLR')
        plt.plot(x, Y_ORLR, linestyle='-', marker='o', markersize=ms, linewidth=3, color='red', label='ORLR')

        plt.xlabel(u'Corruption Ratio')
        plt.ylabel(u'Running Time(s)')

        # plt.xlim(1,len(Y_residual)+1)
        #plt.title(u'Subspace-Accuracy/NMI')

        # plt.yaxis.grid(color='gray', linestyle='dashed')

        leg = plt.gca().legend(loc='upper left')
        leg.get_frame().set_alpha(0.7)
        #plt.yscale('log')

        plt.ylim(-0.1, 5)

        ''''''
        if k == 1 and p == 100 and bNoise == 1:
            plt.ylim(0.1, 0.45)  # used for 1K
        elif k == 2 and p == 100 and bNoise == 1:
            plt.ylim(0.05, 0.45)  # used for 2K
        elif k == 4 and p == 100 and bNoise == 1:
            plt.ylim(0.03, 0.35)  # used for 4K
        elif k == 1 and p == 200 and bNoise == 1:
            plt.ylim(0.15, 0.45)
        elif k == 2 and p == 200 and bNoise == 1:
            plt.ylim(0.1, 0.45)
        elif k == 2 and p == 200 and bNoise == 0:
            plt.ylim(-0.02, 0.45)
        elif k == 4 and p == 400 and bNoise == 0:
            plt.ylim(-0.1, 20)
        plt.show()

        #pp = PdfPages("D:/Dropbox/PHD/publications/IJCAI2017_RLHH/images/beta_1.pdf")
        #plt.savefig(pp, format='pdf')
        #plt.close()


    def draw_runtime_datasize(self, result_dir, cr, p, b, bNoise):

        if bNoise:
            noise_str = ""
        else:
            noise_str = "_nn"

        runtime_file = result_dir + 'runtime_cr' + str(int(cr*100)) + '_' + str(b) + 'B_' + 'p' + str(p) + noise_str + '.mat'
        mat_contents = scipy.io.loadmat(runtime_file)
        Y_OLS = mat_contents["OLS_result"][0].tolist()
        Y_RLHH = mat_contents["RLHH_result"][0].tolist()
        Y_OPAA = mat_contents["OPAA_result"][0].tolist()
        Y_ORL = mat_contents["ORL_result"][0].tolist()
        Y_ORL0 = mat_contents["ORL0_result"][0].tolist()
        Y_DRLR = mat_contents["BatchRC_result"][0].tolist()
        Y_ORLR = mat_contents["OnlineRC_result"][0].tolist()

        #x = [i*0.05 for i in range(2, 25)]
        x = [i for i in range(1, len(Y_ORLR) + 1)]
        # plt.xticks(x, xticks)
        # begin subplots region
        # plt.subplot(121)
        plt.gca().margins(0.1, 0.1)
        ms = 7
        plt.plot(x, Y_OLS, linestyle='--', marker='d', markersize=ms, linewidth=3, color='#5461AA', label='OLS')
        plt.plot(x, Y_RLHH, linestyle='--', marker='o', markersize=ms, linewidth=3, color='green', label='RLHH')
        plt.plot(x, Y_OPAA, linestyle='-.', marker='v', markersize=ms, linewidth=3, color='blue', label='OPAA')
        plt.plot(x, Y_ORL, linestyle='-.', marker='<', markersize=ms, linewidth=3, color='#F27441', label='ORL-H')
        plt.plot(x, Y_ORL0, linestyle='--', marker='s', markersize=ms, linewidth=3, color='#BD90D4', label='ORL*')
        plt.plot(x, Y_DRLR, linestyle=':', marker='^', markersize=ms, linewidth=3, color='cyan', label='DRLR')
        plt.plot(x, Y_ORLR, linestyle='-', marker='o', markersize=ms, linewidth=3, color='red', label='ORLR')

        plt.xlabel(u'Data Size Per Batch(K)')
        plt.ylabel(u'Running Time(s)')

        # plt.xlim(1,len(Y_residual)+1)
        #plt.title(u'Subspace-Accuracy/NMI')

        # plt.yaxis.grid(color='gray', linestyle='dashed')

        leg = plt.gca().legend(loc='upper left')
        leg.get_frame().set_alpha(0.7)
        #plt.yscale('log')

        #plt.ylim(-0.1, 40)
        plt.ylim(-0.1, 7)

        plt.show()

        #pp = PdfPages("D:/Dropbox/PHD/publications/IJCAI2017_RLHH/images/beta_1.pdf")
        #plt.savefig(pp, format='pdf')
        #plt.close()

    def draw_runtime_batchnum(self, result_dir, cr, p, k, bNoise):

        if bNoise:
            noise_str = ""
        else:
            noise_str = "_nn"

        runtime_file = result_dir + 'runtime_cr' + str(int(cr*100)) + '_' + str(k) + 'K_' + 'p' + str(p) + noise_str + '.mat'
        mat_contents = scipy.io.loadmat(runtime_file)
        Y_OLS = mat_contents["OLS_result"][0].tolist()
        Y_RLHH = mat_contents["RLHH_result"][0].tolist()
        Y_OPAA = mat_contents["OPAA_result"][0].tolist()
        Y_ORL = mat_contents["ORL_result"][0].tolist()
        Y_ORL0 = mat_contents["ORL0_result"][0].tolist()
        Y_DRLR = mat_contents["BatchRC_result"][0].tolist()
        Y_ORLR = mat_contents["OnlineRC_result"][0].tolist()

        #x = [i*0.05 for i in range(2, 25)]
        x = [i*2 + 8 for i in range(1, len(Y_ORLR) + 1)]
        # plt.xticks(x, xticks)
        # begin subplots region
        # plt.subplot(121)
        plt.gca().margins(0.1, 0.1)
        ms = 7
        plt.plot(x, Y_OLS, linestyle='--', marker='d', markersize=ms, linewidth=3, color='#5461AA', label='OLS')
        plt.plot(x, Y_RLHH, linestyle='--', marker='o', markersize=ms, linewidth=3, color='green', label='RLHH')
        plt.plot(x, Y_OPAA, linestyle='-.', marker='v', markersize=ms, linewidth=3, color='blue', label='OPAA')
        plt.plot(x, Y_ORL, linestyle='-.', marker='<', markersize=ms, linewidth=3, color='#F27441', label='ORL-H')
        plt.plot(x, Y_ORL0, linestyle='--', marker='s', markersize=ms, linewidth=3, color='#BD90D4', label='ORL*')
        plt.plot(x, Y_DRLR, linestyle=':', marker='^', markersize=ms, linewidth=3, color='cyan', label='DRLR')
        plt.plot(x, Y_ORLR, linestyle='-', marker='o', markersize=ms, linewidth=3, color='red', label='ORLR')

        plt.xlabel(u'Batch Number')
        plt.ylabel(u'Running Time(s)')

        # plt.xlim(1,len(Y_residual)+1)
        #plt.title(u'Subspace-Accuracy/NMI')

        # plt.yaxis.grid(color='gray', linestyle='dashed')

        leg = plt.gca().legend(loc='upper left')
        leg.get_frame().set_alpha(0.7)
        #plt.yscale('log')

        plt.ylim(-0.1, 12)
        #plt.ylim(-20, 40)

        plt.show()

        #pp = PdfPages("D:/Dropbox/PHD/publications/IJCAI2017_RLHH/images/beta_1.pdf")
        #plt.savefig(pp, format='pdf')
        #plt.close()

    def exp_beta_recovery(self):

        result_dir = 'D:/Dropbox/PHD/publications/ICDM2017_OnlineRC/experiment/'

        ''' beta recovery '''
        # figure 1a:
        k = 5
        p = 100
        b = 10
        bNoise = 1
        data_plot.draw_beta_recovery(result_dir, b, k, p, bNoise)

        ## figure 1b
        k = 10
        p = 100
        b = 10
        bNoise = 1
        data_plot.draw_beta_recovery(result_dir, b, k, p, bNoise)

        ## figure 1c
        k = 10
        p = 400
        b = 10
        bNoise = 1
        data_plot.draw_beta_recovery(result_dir, b, k, p, bNoise)

        ## figure 1d
        k = 10
        p = 100
        b = 30
        bNoise = 1
        data_plot.draw_beta_recovery(result_dir, b, k, p, bNoise)

        ## figure 1e
        k = 5
        p = 100
        b = 10
        bNoise = 0
        data_plot.draw_beta_recovery(result_dir, b, k, p, bNoise)

        ## figure 1f
        k = 10
        p = 200
        b = 20
        bNoise = 0
        data_plot.draw_beta_recovery(result_dir, b, k, p, bNoise)

    def exp_runtime(self):
        result_dir = 'D:/Dropbox/PHD/publications/ICDM2017_OnlineRC/experiment/'

        ## Figure 4a
        k = 5
        p = 200
        b = 10
        bNoise = 0
        data_plot.draw_runtime_cr(result_dir, k, p, b, bNoise)

        ## Figure 4b
        p = 100
        cr = 0.4
        b = 10
        bNoise = 1
        data_plot.draw_runtime_datasize(result_dir, cr, p, b, bNoise)

        ## Figure 4c
        p = 100
        cr = 0.4
        k = 5
        bNoise = 1
        data_plot.draw_runtime_batchnum(result_dir, cr, p, k, bNoise)

if __name__ == '__main__':

    data_plot = DataPlot()

    ''' beta recovery '''
    data_plot.exp_beta_recovery()

    ''' runtime '''
    #data_plot.exp_runtime()
