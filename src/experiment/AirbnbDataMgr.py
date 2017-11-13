import csv
import glob
from decimal import Decimal
from re import sub

import numpy
import scipy
import scipy.io

import gzip
class AirbnbDataMgr:

    def __init__(self, data_dir):

        self.data_dir = data_dir
        pass

    def load_feat_list(self):
        self.neighbor_list = self.read_category_feat(self.data_dir + 'neighbor_list.txt')
        self.property_list = self.read_category_feat(self.data_dir + 'property_list.txt')
        self.roomtype_list = self.read_category_feat(self.data_dir + 'roomtype_list.txt')
        self.bedtype_list = self.read_category_feat(self.data_dir + 'bedtype_list.txt')

    def write_neighbor_price(self, neighbor_price_dict, file_name):
        neighbor_file = open(file_name, 'w')
        for item, price_list in neighbor_price_dict.iteritems():
            price = sum(price_list)/float(len(price_list))
            #neighbor_file.write("%s\t%f\n" % item, price)
            if len(item) == 0:
                continue
            str2 = item + '\t' + str(price) + '\n'
            neighbor_file.write(item + '\t' + str(price) + '\n')

    def load_neighbor_price(self):
        self.neighbor_price = {}
        with open(self.data_dir + 'neighbor_price.txt', "r") as file:
            for line in file:
                line = line.strip()
                if len(line) == 0:
                    continue
                item = line.split('\t')[0]
                price = line.split('\t')[1]
                self.neighbor_price[item] = price

    def write_category_feat(self, feat_set, file_name):
        feat_file = open(file_name, 'w')
        for item in feat_set:
            if len(item) == 0:
                continue
            feat_file.write("%s\n" % item)

    def read_category_feat(self, file_name):
        feat_list = []
        with open(file_name, "r") as file:
            for line in file:
                line = line.strip()
                if len(line) == 0:
                    continue
                feat_list.append(line)
        return feat_list


    def load_neighbors(self, data_dir):
        neighbor_set = set()
        property_set = set()
        roomtype_set = set()
        bedtype_set = set()

        neighbor_price_dict = {}
        for file in glob.glob(data_dir + 'train/*.gz'):
            print "======" + file + "======"
            with gzip.open(file, 'r') as fin:
                #next(fin)
                reader = csv.reader(fin)
                sample_list = list(reader)
                title_list = sample_list[0]
                neighbor_idx = title_list.index("neighbourhood_cleansed")
                property_idx = title_list.index("property_type")
                roomtype_idx = title_list.index("room_type")
                bedtype_idx = title_list.index("bed_type")
                for sample in sample_list[1:]:
                    neighbor_name = sample[neighbor_idx]
                    if neighbor_name not in neighbor_price_dict:
                        neighbor_price_dict[neighbor_name] = []
                    price_content = sample[title_list.index("price")]
                    price = float(Decimal(sub(r'[^\d.]', '', price_content)))
                    beds_str = sample[title_list.index("beds")]
                    if len(beds_str) != 0 and float(beds_str) > 0:
                        neighbor_price_dict[neighbor_name].append(price / float(beds_str))
                    else:
                        del neighbor_price_dict[neighbor_name]

                    neighbor_set.add(neighbor_name)
                    property_set.add(sample[property_idx])
                    roomtype_set.add(sample[roomtype_idx])
                    bedtype_set.add(sample[bedtype_idx])
                    sample
            pass
        #print neighbor_set
        self.write_category_feat(neighbor_set, data_dir + 'neighbor_list.txt')
        self.write_category_feat(property_set, data_dir + 'property_list.txt')
        self.write_category_feat(roomtype_set, data_dir + 'roomtype_list.txt')
        self.write_category_feat(bedtype_set, data_dir + 'bedtype_list.txt')
        self.write_neighbor_price(neighbor_price_dict, data_dir + 'neighbor_price.txt')

    def load_feat_file(self, file):
        with open(file, mode='r') as infile:
            reader = csv.reader(infile)
            self.feat_list = next(reader)[1:]
            for feat in reader:
                id = feat[0]
                if id in self.label_dict:
                    self.id_list.append(id)
                    self.feat_dict[id] = feat[1:]
                if len(self.id_list) == self.total_num:
                    pass
                    # break
        pass

    def load_label_file(self, file):
        with open(file, mode='r') as infile:
            reader = csv.reader(infile)
            next(reader)
            for rows in reader:
                id = rows[0]
                self.label_dict[id] = []

                for label in rows[1:6]:
                    self.label_dict[id].append(label)
                #self.id_list.append(id)
                #self.label_dict[id] = rows[2]
                #if len(self.id_list) == 10000:
                #    break
        #self.id_list = self.id_list[1:8000]

    def gen_XY(self, data_dir, sample_size, block_size):


        #dist_feat_num = len(self.neighbor_list) + len(self.property_list) + len(self.roomtype_list) + len(self.bedtype_list)
        dist_feat_num = len(self.property_list) + len(self.roomtype_list) + len(
            self.bedtype_list)
        dist_feat_num = 2

        # cfeat_list = ['id', 'accommodates', 'bathrooms', 'bedrooms', 'beds', 'neighbourhood_cleansed', 'property_type', 'room_type', 'bed_type', 'price']
        cfeat_list = ['accommodates', 'bathrooms', 'bedrooms', 'beds']

        block_num = sample_size / block_size
        # generate the Xtr
        Xtr = numpy.zeros((block_num,), dtype=numpy.object)
        for i in range(block_num):
            Xtr[i] = numpy.zeros(shape=(dist_feat_num + len(cfeat_list), block_size))

        Ytr = numpy.zeros((block_num,), dtype=numpy.object)
        for i in range(block_num):
            Ytr[i] = numpy.zeros(shape=(block_size, 1))

        # Xtr = numpy.zeros(shape=(dist_feat_num + len(cfeat_list), self.train_num))
        # Ytr = numpy.zeros(shape=(self.train_num, 1))
        # Xte = numpy.zeros(shape=(dist_feat_num + len(cfeat_list), self.train_num))
        # Yte = numpy.zeros(shape=(self.train_num, 1))

        sample_idx = 0
        mu, sigma = 0, 20  # mean and standard deviation
        noise = numpy.random.normal(mu, sigma, sample_size)
        # block_idx = 0
        for file in glob.glob(data_dir + '*.gz'):
            print file
            with gzip.open(file, 'r') as fin:
                # next(fin)
                reader = csv.reader(fin)
                sample_list = list(reader)
                title_list = sample_list[0]
                neighbor_idx = title_list.index("neighbourhood_cleansed")
                property_idx = title_list.index("property_type")
                roomtype_idx = title_list.index("room_type")
                bedtype_idx = title_list.index("bed_type")
                for sample in sample_list[1:]:

                    cum_feat_idx = 0
                    '''
                    # neighbor
                    neighbor = sample[neighbor_idx].strip()
                    if len(neighbor) == 0:
                        continue
                    feat_idx = self.neighbor_list.index(neighbor)
                    a = sample_idx % block_size
                    Xtr[sample_idx / block_size][cum_feat_idx + feat_idx][sample_idx % block_size] = 1
                    cum_feat_idx += len(self.neighbor_list)'''

                    neighbor = sample[neighbor_idx].strip()
                    if len(neighbor) == 0:
                        continue
                    #feat_idx = self.neighbor_list.index(neighbor)
                    if neighbor not in self.neighbor_price:
                        continue
                    navg_price = self.neighbor_price[neighbor]
                    Xtr[sample_idx / block_size][cum_feat_idx][sample_idx % block_size] = self.neighbor_price[neighbor]
                    cum_feat_idx += 1

                    '''
                    # property
                    property = sample[property_idx]
                    if len(property) == 0:
                        continue
                    feat_idx = self.property_list.index(property)
                    Xtr[sample_idx / block_size][cum_feat_idx + feat_idx][sample_idx % block_size] = 1
                    cum_feat_idx += len(self.property_list)

                    # room type
                    roomtype = sample[roomtype_idx]
                    if len(roomtype) == 0:
                        continue
                    feat_idx = self.roomtype_list.index(roomtype)
                    Xtr[sample_idx / block_size][cum_feat_idx + feat_idx][sample_idx % block_size] = 1
                    cum_feat_idx += len(self.roomtype_list)

                    # bed type
                    bedtype = sample[bedtype_idx]
                    if len(bedtype) == 0:
                        continue
                    feat_idx = self.bedtype_list.index(bedtype)
                    Xtr[sample_idx / block_size][cum_feat_idx + feat_idx][sample_idx % block_size] = 1
                    cum_feat_idx += len(self.bedtype_list)
                    '''
                    # continuous features
                    invalid_rec = False
                    for feat in cfeat_list:
                        feat_content = sample[title_list.index(feat)]
                        if len(feat_content) == 0:
                            invalid_rec = True
                            break
                        Xtr[sample_idx / block_size][cum_feat_idx][sample_idx % block_size] = feat_content
                        # Xtr[cum_feat_idx][sample_idx] = feat_content
                        cum_feat_idx += 1
                    if invalid_rec:
                        continue

                    # price label for y
                    price_content = sample[title_list.index("price")]
                    price = float(Decimal(sub(r'[^\d.]', '', price_content)))
                    Xtr[sample_idx / block_size][cum_feat_idx][sample_idx % block_size] = price + noise[sample_idx]
                    Ytr[sample_idx / block_size][sample_idx % block_size] = price

                    # update the sample index
                    sample_idx += 1

                    if sample_idx == sample_size:
                        return Xtr, Ytr
                        #scipy.io.savemat(mat_file, mdict={'Xtr_arr': Xtr, 'Ytr_arr': Ytr})
                        #return
            print "sample size:" + str(sample_idx)
            pass

    def gen_mat_file(self, data_dir, sample_size, block_size):

        self.load_feat_list()
        self.load_neighbor_price()
        b_train = 1
        if b_train:
            Xtr, Ytr = self.gen_XY(data_dir + 'train/', sample_size, block_size)
            scipy.io.savemat(data_dir + "NY_train.mat", mdict={'Xtr_arr': Xtr, 'Ytr_arr': Ytr})
        else:
            Xte, Yte = self.gen_XY(data_dir + 'test/', sample_size, block_size)
            scipy.io.savemat(data_dir + "NY_test.mat", mdict={'Xte_arr': Xte, 'Yte_arr': Yte})



if __name__ == '__main__':

    #data_dir = 'D:/Dataset/OnlineRC/airbnb/NY/'
    data_dir = 'D:/Dataset/OnlineRC/airbnb/LA/'
    #data_dir = '/Users/xuczhang/Dataset/PersonPred/age'

    #NY
    #train_num = 320000 #321530
    #test_num = 320000 #329187

    #LA
    train_num = 100000  # 106438
    test_num = 100000  # 103711

    result_dir = 'D:/Dropbox/PHD/publications/ICDM2017_OnlineRC/experiment/'
    dataMgr = AirbnbDataMgr(data_dir)
    #dataMgr.load_neighbors(data_dir)

    #block_size = 20000 #NY
    block_size = 10000 #LA
    dataMgr.gen_mat_file(data_dir, test_num, 10000)
