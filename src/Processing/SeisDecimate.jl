"""
    SeisDecimate(d ; <keyword arguments>)

Decimate a multidimensional array input. Input and output have the same dimension

# Arguments
* `d`: Input data. Between 2D and 5D

# Keyword arguments
* `mode=random`: Data is decimated randomly. Otherwise it is regularly decimated.
* `perc=50`: percentage of traces to be decimated from original array
* `incx1=1,incx2=1,incx3=1,incx4=1`: traces to decimate in case of regular decimation

# Output
* `out`: Decimated data. 

# Example
```julia
julia> d = SeisLinearEvents(d); SeisPlot(d)
julia> d_dec = SeisDecimate(d); SeisPlot(d_dec)
"""

function SeisDecimate(in;mode="random",perc=50,incx1=1,incx2=1,incx3=1,incx4=1)
    
    if (mode=="random") # decimate data randomly
        out = copy(in)
	mask = rand(1,size(in,2)*size(in,3)*size(in,4)*size(in,5));
	mask[find(mask .< perc/100)] = 0;
	mask[find(mask .>= perc/100)] = 1;
	nt=size(in,1)
	out=reshape(out, nt,:)
	for it = 1 : size(in,1)
	    out[it,:] = out[it:it,:].*mask;
	end
	out=reshape(out,size(in))
    else # decimate data regularly with respect to 4 spatial dimensions
        out = zeros(in)
	if size(in,5) > 1
	    out[:,1:incx1:end,1:incx2:end,1:incx3:end,1:incx4:end] = in[:,1:incx1:end,1:incx2:end,1:incx3:end,1:incx4:end]
	elseif size(in,4) > 1
            out[:,1:incx1:end,1:incx2:end,1:incx3:end] = in[:,1:incx1:end,1:incx2:end,1:incx3:end]
        elseif size(in,3) > 1
            out[:,1:incx1:end,1:incx2:end] = in[:,1:incx1:end,1:incx2:end]
        elseif size(in,2) > 1
            out[:,1:incx1:end] = in[:,1:incx1:end]
        end		
	
    end
    
    return out
end
