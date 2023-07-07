import multiprocessing

def job(num):
    return num * 2
p = multiprocessing.Pool(processes=5)
data = p.map(job, [i for i in range(20)])
p.close()
print(data)